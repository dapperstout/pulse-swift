#!/bin/sh

#
# This script sets up an instance of syncthing that can be used to run the integration
# tests. You should have to run this only once for your development setup.
#

################################################################################
### CONFIGURATION
################################################################################

testRoot="/tmp/pulse-swift"
syncthingDir="$testRoot/src/github.com/syncthing"
syncthingAddress="http://127.0.0.1:59296"
syncthingapikey="jobt7d8klok5l8n818q1noq2t683nu"


################################################################################
### DON'T CHANGE BELOW
################################################################################

fatal() {
    echo "[fatal] $1" 1>&2
    exit 1
}

absPath() {
    case "$1" in
        /*)
            printf "%s\n" "$1"
            ;;
        *)
            printf "%s\n" "$PWD/$1"
            ;;
    esac;
}

logStep() {
    echo ""
    echo "$1"
    echo "$1" | sed "s/./-/g"
}

scriptDir="`dirname $0`"
scriptName="`basename $0`"
absScriptDir="`cd $scriptDir; pwd`"

absSyncthingDir="`absPath $syncthingDir`"
gopath=""
syncthing=""
syncthinghome=""

checkPreconditions() {
    logStep "Check preconditions"
    if ( test "$PWD" != "$absScriptDir" ); then
        fatal "This script must be run from the directory where it is stored."
    else
        echo "current dir [ok]"
    fi
    if ( test -d "$syncthingDir" ); then
       fatal "Syncthing folder $syncthingDir already exists."
    else
        echo "syncthing doesn't already exist [ok]"
    fi
    if ( test -z "$GOROOT" || ! test -x "$GOROOT/bin/go" ); then
        fatal "GOROOT must be set and contain executable go"
    else
        echo "GOROOT [ok]"
    fi
    gopath="`echo $absSyncthingDir | sed \"s,/src/github.com/syncthing,,\"`"
    if ( test "$gopath" == "" ); then
        fatal "Could not determine correct go path for building syncthing"
    else
        echo "path for building syncthing [ok]"
    fi
    syncthinghome="$gopath/sthome"
    syncthing="$absSyncthingDir/syncthing/bin/syncthing"
}

cloneSyncThing() {
    logStep "Clone syncthing"
    (
        export GOPATH="$gopath"
        mkdir -p "$syncthingDir" || fatal "Could not create syncthing folder"
        cd "$syncthingDir" || fatal "Could not change to syncthing folder"
        echo "Cloning syncthing... \c"
        ( git clone https://github.com/syncthing/syncthing > $testRoot/syncthing-clone.log 2>&1 ) || fatal "Could not clone syncthing; check log file $testRoot/syncthing-clone.log"
        echo "[ok]"
        (
            cd syncthing || fatal "Could not change to cloned syncthing"
            echo "Building syncthing...\c "
            ( go run build.go > $testRoot/syncthing-build.log 2>&1 ) || fatal "Could not build syncthing; check log file $testRoot/syncthing-build.log"
            echo "[ok]"
        )
    )
}

configureSyncThing() {
    logStep "Configure syncthing"
    mkdir -p "$syncthinghome"
    deviceId=`"$syncthing" -generate="$syncthinghome" | grep "Device ID:" | awk '{print $NF}'`
    (echo "$deviceId" | egrep "^([0-9A-Z]{7}-){7}[0-9A-Z]{7}$" > /dev/null) || fatal "Device id $deviceId does not have expected format"
    config="$syncthinghome/config.xml"
    newconfig="$config.new"
    head -1 $config > $newconfig || fatal "Error modifying config: head"
    echo "    <folder id=\"pulse-integrationTests\" path=\"$syncthinghome/Sync\" ro=\"false\" rescanIntervalS=\"60\" ignorePerms=\"false\">" >> $newconfig || fatal "Error modifying config: folder"
    echo "        <device id=\"$deviceId\"></device>" >> $newconfig || fatal "Error modifying config: deviceid"
    echo "        <versioning></versioning>" >> $newconfig || fatal "Error modifying config: versioning"
    echo "        <lenientMtimes>false</lenientMtimes>" >> $newconfig || fatal "Error modifying config: lenientMtimes"
    echo "        <copiers>0</copiers>" >> $newconfig || fatal "Error modifying config: copiers"
    echo "        <pullers>0</pullers>" >> $newconfig || fatal "Error modifying config: pullers"
    echo "        <finishers>0</finishers>" >> $newconfig || fatal "Error modifying config: finishers"
    echo "    </folder>" >> $newconfig || fatal "Error modifying config: /folder"
    tail -n +2 $config >> $newconfig || fatal "Error modifying config: tail"
    mv -f $newconfig $config  || fatal "Error modifying config: mv"
    echo "config created [ok]"

    echo "Syncthing config check...\c "
    (
        sleep 20
        curl -s -H "X-API-Key:$syncthingapikey" -X POST $syncthingAddress/rest/shutdown > /dev/null
    ) &
    $syncthing -home="$syncthinghome" -no-browser -gui-apikey="$syncthingapikey" -gui-address="$syncthingAddress" > $testRoot/syncthingcheck.log || fatal "Syncthing config check error; check log file $testRoot/syncthingcheck.log"
    echo "[ok]"
}

main() {
    checkPreconditions
    cloneSyncThing
    configureSyncThing
    
    echo ""
    echo "Bootstrap done. Syncthing available at: $syncthing"
    echo ""
}

main $*

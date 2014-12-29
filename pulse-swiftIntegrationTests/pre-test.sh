#!/bin/sh

# Setup syncthing if not already done
if ( ! test -d /tmp/pulse-swift ); then
    (
		d="`dirname $0`"
        cd "$d"
        "./bootstrap.sh"
    )
fi

# Start syncthing if it is not already running
if ( ! curl -s -H "X-API-Key:jobt7d8klok5l8n818q1noq2t683nu" -X POST http://127.0.0.1:59296/rest/ping > /dev/null ); then
    /tmp/pulse-swift/src/github.com/syncthing/syncthing/bin/syncthing -home=/tmp/pulse-swift/sthome -no-browser -gui-apikey="jobt7d8klok5l8n818q1noq2t683nu" -gui-address="http://127.0.0.1:59296" &
    touch /tmp/pulse-swift/started-by-build-script
    sleep 10
fi

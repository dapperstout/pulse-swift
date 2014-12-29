#!/bin/sh

if ( test -z "$BUILD_ROOT" || test -f /tmp/pulse-swift/started-by-build-script ); then
    curl -s -H "X-API-Key:jobt7d8klok5l8n818q1noq2t683nu" -X POST http://127.0.0.1:59296/rest/shutdown
    sleep 3
    rm -f /tmp/pulse-swift/started-by-build-script
fi

#!/usr/bin/env bash

start() {
    local tag="$1"
    local cmd="$2"
    local dir="$3"

    local log="${tag}.log"

    if [ -d "$dir" ]; then
        cd "$dir"
    fi
    rm -f "$log"

    echo "Starting: $tag"
    eval $cmd 2>&1 | while read line; do
        echo "$(date) - $tag: $line"
        echo "$line" >> "$log"
    done

    echo "$tag exited with exit code: $?"
}

(start "strelaysrv" "strelaysrv "$RELAY_ARGS"", "/strelaysrv") &
(start "stdiscosrv" "stdiscosrv "$DISCOVER_ARGS"", "/stdiscosrv") &

wait -n
exit $?


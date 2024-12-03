#/bin/bash
# A test script validating a few scenarios for the update
# script for the Debian Mirror.

source debian-mirror-sync-check.sh --test

echo "Testing debian mirror update script"

function test_should_pull() {
    local local_time=$1
    local upstream_time=$2
    local current_time=$3
    local expected=$4
    # echo "should_pull: $1 $2 $3 - expected: $4"
    local result=$(should_pull "$local_time" "$upstream_time" "$current_time")
    if [ "$result" == "$expected" ]; then
        echo "Test passed"
    else
        echo "Test failed - expected |$expected|, got |$result|"
    fi
}

# Local time is newer than the upstream time, so no pull.
test_should_pull "Wed Nov 20 18:02:35 UTC 2024" "Wed Nov 20 17:42:05 UTC 2024" "Wed Nov 20 18:02:35 UTC 2024" "false"
# Same as above. The current time is different (and it does not matter)
test_should_pull "Wed Nov 20 18:02:35 UTC 2024" "Wed Nov 20 17:42:05 UTC 2024" "Wed Nov 21 18:02:35 UTC 2024" "false"

# Local time is older than the upstream time, but the upstream time is less than 2 hours ago.
test_should_pull "Wed Nov 20 17:42:05 UTC 2024" "Wed Nov 20 18:02:35 UTC 2024" "Wed Nov 20 19:58:35 UTC 2024" "false"
# Same as above. The current time is just over 2 hours ago.
test_should_pull "Wed Nov 20 17:42:05 UTC 2024" "Wed Nov 20 18:02:35 UTC 2024" "Wed Nov 20 20:02:35 UTC 2024" "true"

# Testing the sample where we had a misbehavior because old repo was too old
test_should_pull "Thu Nov 28 16:21:17 UTC 2024" "Mon Dec  2 19:42:01 UTC 2024" "Mon Dec  2 09:40:11 PM UTC 2024" "true"
# Local time is older than the upstream time, but the upstream time is less than 2 hours ago.
test_should_pull "Wed Nov 20 16:42:05 UTC 2024" "Wed Nov 20 19:52:35 UTC 2024" "Wed Nov 20 20:58:35 UTC 2024" "false"

# This should not be possible, but what if current time is older than the local time
test_should_pull "Wed Nov 20 18:02:35 UTC 2024" "Wed Nov 20 17:42:05 UTC 2024" "Wed Nov 20 17:42:05 UTC 2024" "false"

#!/bin/bash

# Fetch time from Cloudflare's Roughtime server
time=$( /opt/roughtime/roughtime-client -addr us.pool.roughtime.cloudflare.com:2002 -pubkey C3443D12FEE424FC368728A5B21A0CD6DB64D5ED | grep -oP 'UTC time: \K\S+' )

# Set the system clock to the fetched time
if [ ! -z "$time" ]; then
    date -s @$((time / 1000000000))
    echo "Time successfully updated from Roughtime"
else
    echo "Failed to fetch time from Roughtime"
fi


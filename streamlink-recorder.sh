#!/bin/sh

# For more information visit: https://github.com/downthecrop/TwitchVOD

while [ true ]; do
	Date=$(date +%Y%m%d-%H%M%S)
	streamlink $streamOptions $streamLink $streamQuality -o /home/download | ffmpeg -i pipe:0 -c copy -f mp4 /home/download/$streamName"-$Date".mp4
	sleep 60s
done

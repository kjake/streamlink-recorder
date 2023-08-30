#!/bin/sh

# For more information visit: https://github.com/downthecrop/TwitchVOD

while [ true ]; do
    streamDate=$(date +"%Y-%m-%d %Hh%Mm%Ss")
	# Get stream info as JSON
	streamInfo=$(streamlink $streamOptions $streamLink $streamQuality -j)
	# Extract stream title from JSON
	streamTitle=$(echo $streamInfo | jq -r '.metadata.title')
	# Download and convert stream
	streamlink $streamOptions $streamLink $streamQuality -o "/home/download/${streamName} - ${streamDate} - ${streamTitle}.mkv"
	sleep ${streamPoll:-60}s
done

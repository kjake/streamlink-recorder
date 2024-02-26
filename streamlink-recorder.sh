#!/bin/sh

# For more information visit: https://github.com/downthecrop/TwitchVOD

while [ true ]; do
    streamDate=$(date +"%Y-%m-%d %Hh%Mm%Ss")
	# Get stream info as JSON
	streamInfo=$(streamlink $streamOptions $streamLink $streamQuality -j)
	# Extract stream title from JSON
	streamTitle=$(echo $streamInfo | jq -r '.metadata.title')
	# Download and convert stream
	streamlink $streamOptions $streamLink $streamQuality -O | ffmpeg -fflags +discardcorrupt -i pipe:0 -c:v copy -c:a copy "/home/download/${streamName} - ${streamDate} - ${streamTitle}.mp4"
	sleep 60s
done

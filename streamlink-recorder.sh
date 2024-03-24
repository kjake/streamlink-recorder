#!/bin/sh

# For more information visit: https://github.com/downthecrop/TwitchVOD

while [ true ]; do
    streamDate=$(date +"%Y-%m-%d %Hh%Mm%Ss")
	# Get stream info as JSON
	streamInfo=$(streamlink $streamOptions $streamLink $streamQuality -j)
	# Extract stream title from JSON
	streamTitle=$(echo $streamInfo | jq -r '.metadata.title')
	# Download and convert stream
	streamlink $streamOptions $streamLink $streamQuality --stdout | ffmpeg -fflags +discardcorrupt -i pipe:0 -c copy -bsf:a aac_adtstoasc -f mp4 -y "/home/download/${streamName} - ${streamDate} - ${streamTitle}.mp4"
	sleep ${streamPoll:-60}s
done

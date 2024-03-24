#!/bin/sh

# For more information visit: https://github.com/downthecrop/TwitchVOD

while [ true ]; do
    streamDate=$(date +"%Y-%m-%d %Hh%Mm%Ss")
	# Get stream info as JSON
	streamInfo=$(streamlink $streamOptions $streamLink $streamQuality -j)
	# Assume that, if streamInfo is empty or actually returns an error message, the stream is not live
    if [ ! -z "$streamInfo" ] && ! echo "$streamInfo" | grep -q "error"; then
		# Extract stream title from JSON
		streamTitle=$(echo $streamInfo | jq -r '.metadata.title')

		# Download and convert stream
		streamlink $streamOptions $streamLink $streamQuality --stdout | ffmpeg -fflags +discardcorrupt -i pipe:0 -c copy -bsf:a aac_adtstoasc -f mp4 -loglevel error -y "/home/download/${streamName} - ${streamDate} - ${streamTitle}.mp4"
	else
		echo $streamInfo | jq -r '.error'
	fi
	sleep ${streamPoll:-60}s
done

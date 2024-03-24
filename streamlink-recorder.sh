#!/bin/sh

# For more information visit: https://github.com/downthecrop/TwitchVOD

while [ true ]; do
    streamDate=$(date +"%Y-%m-%d %Hh%Mm%Ss")
	# Get stream info as JSON
	streamInfo=$(streamlink $streamOptions $streamLink $streamQuality -j)
	# Extract stream title from JSON
	streamTitle=$(echo $streamInfo | jq -r '.metadata.title')
	# Download and convert stream
	streamlink $streamOptions $streamLink $streamQuality --stdout | ffmpeg -init_hw_device vaapi=foo:/dev/dri/renderD128 -hwaccel vaapi -hwaccel_output_format vaapi -hwaccel_device foo -i pipe:0 -filter_hw_device foo -vf 'format=nv12|vaapi,hwupload' -c:v h264_vaapi -c:a copy -movflags +faststart -f mp4 -loglevel error -y "/home/download/${streamName} - ${streamDate} - ${streamTitle}.mp4"
	sleep ${streamPoll:-60}s
done

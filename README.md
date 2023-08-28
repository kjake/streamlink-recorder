# docker-streamlink-recorder

Automated Dockerfile to record livestreams with streamlink forked from lauwarm/streamlink-recorder

## Description

This is a Docker Container to record a livestream. It uses the official [Python Image](https://hub.docker.com/_/python) with the Tag *bullseye*  , installs [streamlink](https://github.com/streamlink/streamlink) and uses the Script [streamlink-recorder.sh](https://raw.githubusercontent.com/lauwarm/docker-streamlink-recorder/main/streamlink-recorder.sh) to periodically check if the stream is live.

## Usage

To run the Container:

```
version: "3"
services:
  record:
   image: ghcr.io/kimpig/streamlink-recorder-mp4:main
   container_name: Streamlink-Recorder
   restart: unless-stopped
   volumes:
      - /volume1/docker/Twitch-recorder/poqrs3077:/home/download
   environment:
      - streamName=urtwitchstreamer
      - streamLink=twitch.tv/urtwitchstreamer
      - streamQuality=best
      - streamOptions=--twitch-disable-hosting --twitch-disable-ads
      - uid=
      - gid=
      - TZ=Asia/Seoul
```

## Notes

`/home/download` - the place where the vods will be saved. Mount it to a desired place with `-v` option.

`/home/script` - the place where the scripts are stored. (entrypoint.sh and streamlink-recorder.sh)

`/home/plugins` - the place where the streamlink plugins are stored.

`streamLink` - the url of the stream you want to record.

`streamQuality` - quality options (best, high, medium, low).

`streamName` - name for the stream.

`streamOptions` - streamlink flags (--twitch-disable-reruns, separated by space, see [Plugins](https://streamlink.github.io/plugins.html))

`uid` - USER ID, map to your desired User ID (fallback to 9001)

`gid` - GROUP ID, map to your desired Group ID (fallback to 9001)

The File will be saved as `streamName - Year-Month-Day HourMinuteSecond - streamTitle.mp4`

Also, The File format will be MP4, not TS (depending on ffmpeg)

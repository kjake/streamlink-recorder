## Description

This is a Docker Container to record a livestream into a MP4 file. It uses the official [Alpine Image](https://hub.docker.com/_/alpine) with the Tag *latest*, installs [streamlink](https://github.com/streamlink/streamlink), [ffmpeg](https://github.com/FFmpeg/FFmpeg), and runs a modified version of the script [streamlink-recorder.sh](https://raw.githubusercontent.com/lauwarm/docker-streamlink-recorder/main/streamlink-recorder.sh) to periodically check if the stream is live.

> [!WARNING]
> I have been testing and using this with Twitch only, which uses AAC audio streams. This implementation is assuming AAC audio and running a minor conversion on the audio stream to be more compatible with the MP4 container.

## Usage Example

docker-compose.yaml:
```yaml
version: "3"
services:
  record:
   image: kjake/streamlink-recorder
   container_name: Streamlink-Recorder
   restart: unless-stopped
   volumes:
      - /volume1/docker/Twitch-recorder/urtwitchstreamer:/home/download
   environment:
      - streamName=urtwitchstreamer
      - streamLink=twitch.tv/urtwitchstreamer
      - streamQuality=best
      - streamOptions=--twitch-disable-hosting --twitch-disable-ads
      - streamPoll=60
      - uid=9001
      - gid=9001
      - TZ=Asia/Seoul
```

docker on cli:
```shell
docker run -d \
  --name='Streamlink-Recorder' \
  -e TZ='Asia/Seoul' \
  -e streamLink='twitch.tv/urtwitchstreamer' \
  -e streamName='urtwitchstreamer' \
  -e streamQuality='best' \
  -e streamOptions='--twitch-disable-hosting --twitch-disable-ads' \
  -e streamPoll=60 \
  -e gid=9001 \
  -e uid=9001 \
  -v /volume1/docker/Twitch-recorder/urtwitchstreamer:/home/download:rw \
  --restart=unless-stopped kjake/streamlink-recorder
```

## Notes

`/home/download` - the place where the vods will be saved. Mount it to a desired place with `-v` option.

`/home/script` - the place where the scripts are stored. (entrypoint.sh and streamlink-recorder.sh)

`/home/plugins` - the place where the streamlink plugins are stored.

`streamLink` - the url of the stream you want to record.

`streamQuality` - quality options (best, high, medium, low).

`streamName` - name for the stream.

`streamOptions` - streamlink flags (`--twitch-disable-reruns`, separated by space, see [Plugins](https://streamlink.github.io/plugins.html))

`streamPoll` - freqency (in seconds) to poll `streamLink` for a new stream.

`uid` - USER ID, map to your desired User ID (fallback to 9001)

`gid` - GROUP ID, map to your desired Group ID (fallback to 9001)

> [!NOTE]
> The stream file will be named as `streamName - Year-Month-Day HourMinuteSecond - streamTitle.mp4`.

## Acknowledgments
- Thanks to [@KimPig](https://github.com/KimPig/streamlink-recorder-mp4) for the original idea for an MP4 container.
- Thanks to [@lauwarm](https://github.com/lauwarm/docker-streamlink-recorder) for the original streamlink container.

## Contributions

If you see out of date documentation, things aren't working, have an idea, etc., you can help out by either:
- creating an issue, or
- sending a pull request with modifications

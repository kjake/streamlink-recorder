FROM python:alpine
LABEL maintainer="kjake"

ENV streamlinkCommit=8d73b096066e3a84af4057f5aa589f7a65e5ab34

RUN apk add --update --no-cache && \
    apk add --no-cache gosu --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ && \
    # needed to support VAAPI, but basically limits architectures to only amd64
    # apk add --no-cache intel-media-driver libva-intel-driver libva-vdpau-driver --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community/ && \
    apk add --no-cache py3-pip jq git ffmpeg ca-certificates && \
    pip3 install --upgrade git+https://github.com/streamlink/streamlink.git@${streamlinkCommit} && \
	echo 'export PATH="${HOME}/.local/bin:${PATH}"' && \
    mkdir /home/download && \
    mkdir /home/script && \
    mkdir /home/plugins && \
    apk del git && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/ ~/.cache/pip


COPY ./streamlink-recorder.sh /home/script/
COPY ./entrypoint.sh /home/script

RUN ["chmod", "+x", "/home/script/entrypoint.sh"]

ENTRYPOINT [ "/home/script/entrypoint.sh" ]

CMD /bin/sh /home/script/streamlink-recorder.sh ${streamOptions} ${streamLink} ${streamQuality} ${streamName} ${streamPoll}

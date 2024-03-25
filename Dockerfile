FROM alpine:latest
LABEL maintainer="kjake"

COPY ./repositories /etc/apk/

RUN apk add --update --no-cache && \
    # the following would be needed to support VAAPI, but essentially limits architectures to only amd64
    # intel-media-driver libva-intel-driver libva-vdpau-driver
    apk add --no-cache gosu streamlink jq ca-certificates tzdata

RUN mkdir /home/download /home/script /home/plugins && \
    rm -rf /var/cache/apk/* /tmp/* /var/tmp/

COPY ./streamlink-recorder.sh /home/script/
COPY ./entrypoint.sh /home/script

RUN ["chmod", "+x", "/home/script/entrypoint.sh"]

ENTRYPOINT [ "/home/script/entrypoint.sh" ]

CMD /bin/sh /home/script/streamlink-recorder.sh ${streamOptions} ${streamLink} ${streamQuality} ${streamName} ${streamPoll}

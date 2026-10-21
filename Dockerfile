ARG PYTHON_VERSION=3.14

FROM cgr.dev/chainguard/wolfi-base AS build
ARG PYTHON_VERSION

RUN apk add --no-cache \
        python-${PYTHON_VERSION} \
        py${PYTHON_VERSION}-pip

# streamlink and its dependencies ship prebuilt wheels for amd64 and arm64,
# so no compiler toolchain is needed. pip is only needed at build time.
RUN python${PYTHON_VERSION} -m venv /opt/streamlink && \
    /opt/streamlink/bin/pip install --no-cache-dir streamlink && \
    /opt/streamlink/bin/pip uninstall -y pip

FROM cgr.dev/chainguard/wolfi-base
LABEL maintainer="kjake"
ARG PYTHON_VERSION

# the following packages would be needed to support VAAPI, but essentially limits architectures to only amd64
# intel-media-driver libva-intel-driver libva-vdpau-driver

RUN apk add --no-cache \
        python-${PYTHON_VERSION} \
        tzdata \
        jq \
        gosu

COPY --from=build /opt/streamlink /opt/streamlink
ENV PATH="/opt/streamlink/bin:${PATH}"

RUN addgroup -S -g 9001 streamlink && \
    adduser -S -D -H -u 9001 -G streamlink streamlink

RUN mkdir /home/download /home/script /home/plugins

COPY ./streamlink-recorder.sh /home/script/
COPY ./entrypoint.sh /home/script

RUN ["chmod", "+x", "/home/script/entrypoint.sh"]

ENTRYPOINT [ "/home/script/entrypoint.sh" ]

CMD /bin/sh /home/script/streamlink-recorder.sh ${streamOptions} ${streamLink} ${streamQuality} ${streamName} ${streamPoll}

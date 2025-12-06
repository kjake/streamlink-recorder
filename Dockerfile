FROM kjake/base
LABEL maintainer="kjake"

ARG BUILD_PACKAGES="build-essential \
    python3-dev \
    libxml2-dev \
    libxslt1-dev"
    
# the following packages would be needed to support VAAPI, but essentially limits architectures to only amd64
# intel-media-driver libva-intel-driver libva-vdpau-driver

RUN apt-get -qq update && \
    apt-get install -y --no-install-recommends \
        ${BUILD_PACKAGES} \
        python3 \
        python3-venv \
        pipx \
        tzdata \
        jq \
        gosu

RUN pipx install --pip-args="--no-cache-dir" streamlink --global && \
    pipx ensurepath --global

RUN apt-get -qq remove -y ${BUILD_PACKAGES}

RUN groupadd -r streamlink -g 9001 && useradd --no-log-init -r -g 9001 -u 9001 streamlink

RUN mkdir /home/download /home/script /home/plugins && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

COPY ./streamlink-recorder.sh /home/script/
COPY ./entrypoint.sh /home/script

RUN ["chmod", "+x", "/home/script/entrypoint.sh"]

ENTRYPOINT [ "/home/script/entrypoint.sh" ]

CMD /bin/sh /home/script/streamlink-recorder.sh ${streamOptions} ${streamLink} ${streamQuality} ${streamName} ${streamPoll}

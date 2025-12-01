FROM kjake/base
LABEL maintainer="kjake"

RUN  apt-get -qq update && \
      apt-get install -y --no-install-recommends \
         python3 \
         python3-venv \
         pipx \
         curl \
         jq \
         tzdata \
         wget \
         gosu && \
      latest_streamlink_url="$(curl -fsSL https://api.github.com/repos/streamlink/streamlink/releases/latest | jq -r '.assets[] | select(.name | endswith("py3-none-any.whl")) | .browser_download_url')" && \
      pipx install --pip-args="--no-cache-dir" "${latest_streamlink_url}"
     # the following would be needed to support VAAPI, but essentially limits architectures to only amd64
     # intel-media-driver libva-intel-driver libva-vdpau-driver

ENV PATH="/root/.local/bin:${PATH}"

RUN mkdir /home/download /home/script /home/plugins && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

COPY ./streamlink-recorder.sh /home/script/
COPY ./entrypoint.sh /home/script

RUN ["chmod", "+x", "/home/script/entrypoint.sh"]

ENTRYPOINT [ "/home/script/entrypoint.sh" ]

CMD /bin/sh /home/script/streamlink-recorder.sh ${streamOptions} ${streamLink} ${streamQuality} ${streamName} ${streamPoll}

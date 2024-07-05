FROM archlinux:latest
LABEL maintainer="kjake"

RUN sed -i '/^\[extra\]/,/^Include/s/^#//' /etc/pacman.conf

RUN pacman -Syu --noconfirm && \
    # the following would be needed to support VAAPI, but essentially limits architectures to only amd64
    # intel-media-driver libva-intel-driver libva-vdpau-driver
    pacman -S --noconfirm streamlink jq ca-certificates tzdata wget gnupg

ENV GOSU_VERSION 1.17
RUN set -eux; \
    pacmanArch="$(pacman -Q --info pacman | grep Architecture | awk '{ print $3 }')"; \
	case "$pacmanArch" in \
		aarch64) pacmanArch='arm64' ;; \
		armv[67]*) pacmanArch='armhf' ;; \
		i[3456]86) pacmanArch='i386' ;; \
		ppc64le) pacmanArch='ppc64el' ;; \
		riscv64 | s390x) pacmanArch="$rpmArch" ;; \
		x86_64) pacmanArch='amd64' ;; \
		*) echo >&2 "error: unknown/unsupported architecture '$pacmanArch'"; exit 1 ;; \
	esac; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$pacmanArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$pacmanArch.asc"; \
    \
# verify the signature
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    \
    chmod +x /usr/local/bin/gosu;

RUN mkdir /home/download /home/script /home/plugins && \
    rm -rf /var/cache/pacman/pkg/* /tmp/* /var/tmp/

COPY ./streamlink-recorder.sh /home/script/
COPY ./entrypoint.sh /home/script

RUN ["chmod", "+x", "/home/script/entrypoint.sh"]

ENTRYPOINT [ "/home/script/entrypoint.sh" ]

CMD /bin/sh /home/script/streamlink-recorder.sh ${streamOptions} ${streamLink} ${streamQuality} ${streamName} ${streamPoll}

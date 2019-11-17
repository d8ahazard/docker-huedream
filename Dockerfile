FROM lsiobase/mono:LTS

# set version label
ARG HUEDREAM_RELEASE
LABEL build_version="Digitalhigh 1.0.0"
LABEL maintainer="Digitalhigh"

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV XDG_CONFIG_HOME="/config/xdg"

RUN \
 echo "**** install jq ****" && \
 apt-get update && \
 apt-get install -y \
	jq && \
 echo "**** install huedream ****" && \
 if [ -z ${HUEDREAM_RELEASE+x} ]; then \
	HUEDREAM_RELEASE=$(curl -sX GET "https://api.github.com/repos/d8ahazard/HueDream/releases" \
	| jq -r '.[0] | .tag_name'); \
 fi && \
 huedream_url=$(curl -s https://api.github.com/repos/d8ahazard/HueDream/releases/tags/"${HUEDREAM_RELEASE}" \
	|jq -r '.assets[].browser_download_url') && \
 mkdir -p \
	/opt/huedream && \
 curl -o \
 /tmp/huedream.zip -L \
	"${huedream_url}" && \
 unzip \
 /tmp/huedream.zip -d \
	/opt/huedream && \
 echo "**** clean up ****" && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 5000

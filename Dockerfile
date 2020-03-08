FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim
ENV ASPNETCORE_URLS=http://+:5666

# set version label
ARG HUEDREAM_RELEASE
LABEL build_version="Digitalhigh 1.1.2a"
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
 echo "Huedream release is " ${HUEDREAM_RELEASE} && \
 huedream_url=$(curl -s https://api.github.com/repos/d8ahazard/HueDream/releases/tags/"${HUEDREAM_RELEASE}" \
	|jq -r '.assets[].browser_download_url' |grep linux) && \
 mkdir -p \
	/opt/huedream && \
 mkdir -p /etc/huedream && \
 echo "Huedream URL is " ${huedream_url} && \
 curl -o \
 /tmp/huedream.tar.gz -L \
	"${huedream_url}" && \
 tar ixzf \
 /tmp/huedream.tar.gz -C \
	/opt/huedream && \
 echo "**** clean up ****" && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY /root /

# ports and volumes
VOLUME /etc/huedream
EXPOSE 1900/udp
EXPOSE 2100/udp
EXPOSE 5699
EXPOSE 8888/udp

FROM ubuntu:20.04
USER root
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive TZ=UTC
RUN apt update && \
	apt upgrade -y && \
	apt install -y \
		tzdata bash curl jq gnupg python3

# Install subkey
# RUN gpg --recv-keys --keyserver hkps://keys.mailvelope.com 9D4B2B6EB8F97156D19669A9FF0812D491B96798 && \
#     gpg --export 9D4B2B6EB8F97156D19669A9FF0812D491B96798 > /usr/share/keyrings/parity.gpg && \
#     echo 'deb [signed-by=/usr/share/keyrings/parity.gpg] https://releases.parity.io/deb release main' > /etc/apt/sources.list.d/parity.list && \
# 	curl https://getsubstrate.io -sSf | bash
# ENV PATH="${PATH}:/root/.cargo/bin"

# Uncomment if need install nodejs
# RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash -
# RUN apt install -y nodejs

# Add pontem
WORKDIR /opt/pontem
ARG PONTEM_VERSION
RUN curl -#kSLf -o "pontem" "https://github.com/pontem-network/pontem/releases/download/${PONTEM_VERSION}/pontem-ubuntu-x86_64" && \
	chmod +x pontem
ENV PATH="${PATH}:/opt/pontem"

STOPSIGNAL SIGTERM
ENTRYPOINT [""]
# CMD ["/bin/bash", "-c"]

FROM ubuntu:20.04 as prepare
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get dist-upgrade -y -o Dpkg::Options::="--force-confold" && \
    apt-get install -y cmake pkg-config libssl-dev git clang bash build-essential libc6 libc-bin curl
SHELL ["/bin/bash", "-c"]
ENV PATH="${PATH}:/root/.cargo/bin"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
RUN rustup update stable
WORKDIR /opt

FROM prepare as move-tools
ARG DOVE_VERSION
RUN git clone -b ${DOVE_VERSION} https://github.com/pontem-network/move-tools.git && \
    cd move-tools && \
    cargo build --release --bins -p dove

FROM move-tools as build
COPY --from=move-tools /opt/move-tools/target/release/dove /usr/local/bin/dove
ARG PONTEM_VERSION
RUN git clone -b ${PONTEM_VERSION} https://github.com/pontem-network/pontem.git
WORKDIR /opt/pontem
RUN make init
RUN cargo clean -p pontem-node
RUN rustup target add wasm32-unknown-unknown && \
	make test && make build && \
	mkdir -p release && \
	cp target/release/pontem release/

FROM ubuntu:20.04
WORKDIR /opt/pontem
ENV PATH="${PATH}:/opt/pontem"
COPY --from=build /opt/pontem/release/* ./
STOPSIGNAL SIGTERM
ENTRYPOINT [""]
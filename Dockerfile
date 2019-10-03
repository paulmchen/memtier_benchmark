FROM ubuntu:18.04 as builder
RUN apt-get update
RUN \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install -y \
    build-essential autoconf automake libpcre3-dev libevent-dev \
    pkg-config zlib1g-dev git libboost-all-dev cmake flex libssl-dev
RUN git clone https://github.com/RedisLabs/memtier_benchmark.git
WORKDIR /memtier_benchmark
RUN autoreconf -ivf && ./configure && make && make install

FROM ubuntu:18.04
LABEL Description="memtier_benchmark"
COPY --from=builder /usr/local/bin/memtier_benchmark /usr/local/bin/memtier_benchmark
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
      libevent-dev \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/

ENTRYPOINT ["memtier_benchmark"]

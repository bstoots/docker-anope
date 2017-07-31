FROM ubuntu:16.04
MAINTAINER Brian Stoots <bstoots@gmail.com>

# Install required packages to make it go
RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  gnutls-bin gnutls-dev \
  libpcre3 libpcre3-dev \
  libwww-perl \
  pkg-config \
  sudo \
  wget

# Get the source
WORKDIR /var/tmp
RUN wget https://github.com/anope/anope/releases/download/2.0.5/anope-2.0.5-source.tar.gz && tar xf anope-2.0.5-source.tar.gz

# Configure
WORKDIR /var/tmp/anope-2.0.5-source
RUN cmake \
  # cmake options
  -DINSTDIR:STRING=/opt/anope \
  -DDEFUMASK:STRING=077 \
  -DCMAKE_BUILD_TYPE:STRING=RELEASE \
  -DUSE_RUN_CC_PL:BOOLEAN=ON \
  # make / install
  && make && make install

# RUN rm -rf /var/tmp/anope-2.0.5-source

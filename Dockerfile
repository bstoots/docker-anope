FROM ubuntu:16.04
MAINTAINER Brian Stoots <bstoots@gmail.com>

# Install required packages to make it go
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
  build-essential \
  cmake \
  gettext \
  gnutls-bin gnutls-dev \
  libpcre3 libpcre3-dev \
  libwww-perl \
  pkg-config \
  sudo \
  wget

# Get the source
WORKDIR /var/tmp
RUN wget https://github.com/anope/anope/releases/download/2.0.5/anope-2.0.5-source.tar.gz && tar xf anope-2.0.5-source.tar.gz

# Configure, make, and install
WORKDIR /var/tmp/anope-2.0.5-source
RUN cp modules/extra/m_regex_posix.cpp modules/m_regex_posix.cpp \
 && cp modules/extra/m_ssl_gnutls.cpp modules/m_ssl_gnutls.cpp
RUN cmake \
  -DINSTDIR:STRING=/opt/anope \
  -DDEFUMASK:STRING=077 \
  -DCMAKE_BUILD_TYPE:STRING=RELEASE \
  -DUSE_RUN_CC_PL:BOOLEAN=ON \
  && make && make install

# Change into user mode
RUN chown irc:irc -R /opt/anope
USER irc:irc
WORKDIR /opt/anope

VOLUME ["/opt/anope/conf"]
VOLUME ["/opt/anope/data"]

EXPOSE 7000

ENTRYPOINT ["bin/services"]
CMD ["--nofork"]

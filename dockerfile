FROM debian:8.11@sha256:23f6c1ca631220b4a17c659e70e4c20092965590b406b1fb02780475680622f4
LABEL maintainer="ahiru <ahiru-san@outlook.com>"

ENV READYNASOS_VERSION 6.10.4
ENV READYNAS_GPG readynas-pub.gpg

COPY $READYNAS_GPG /tmp/.
RUN apt-key add /tmp/${READYNAS_GPG} \
 && rm /tmp/${READYNAS_GPG}

RUN echo "deb http://apt.readynas.com/packages/readynasos $READYNASOS_VERSION updates main dev" > /etc/apt/sources.list.d/readynas.list \
 && echo "Package: *" > /etc/apt/preferences.d/readynasos \
 && echo "Pin: origin apt.readynas.com" >> /etc/apt/preferences.d/readynasos \
 && echo "Pin-Priority: 900" >> /etc/apt/preferences.d/readynasos

RUN set -x \
 && dpkg --add-architecture amd64 \
 && dpkg --add-architecture armel \
 && dpkg --add-architecture armhf \
 && apt-get -y update \
 && apt-get -y install readynas-build-deps \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]

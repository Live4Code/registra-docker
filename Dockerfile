FROM dspfac/alpine:latest

ENV REGISTRATOR_PATH github.com/gliderlabs/registrator
ENV REGISTRATOR_REPO https://${REGISTRATOR_PATH}.git
ENV REGISTRATOR_BRANCH master
ENV GOPATH /usr


RUN apk-install -t build-deps go git mercurial && \
git clone -b ${REGISTRATOR_BRANCH} ${REGISTRATOR_REPO} ${GOPATH}/src/${REGISTRATOR_PATH} && \
  cd ${GOPATH}/src/${REGISTRATOR_PATH} && \
  go get && \
  go build -ldflags "-X main.Version $(cat VERSION)" -o /bin/registrator && \
  apk del --purge build-deps && \
  rm -rf /var/cache/apk/* && \
  rm -r /usr/src/*

ADD rootfs /

WORKDIR /root
CMD ["/usr/bin/s6-svscan","/etc/s6"]
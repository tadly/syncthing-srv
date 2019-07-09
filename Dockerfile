FROM golang:alpine AS builder

ENV PKGVER 1.2.0

RUN apk add --no-cache ca-certificates curl \
    && mkdir -p /go \
    && cd /go \
    && mkdir -p src/github.com/syncthing \
    && export SRCDIR=$PWD \
    && cd src/github.com/syncthing \
    && curl -L https://github.com/syncthing/syncthing/releases/download/v${PKGVER}/syncthing-source-v${PKGVER}.tar.gz | tar xzf - \
    && cd syncthing \
    && export GOPATH="$SRCDIR" GOROOT_FINAL="/usr/bin" \
    && go run build.go -no-upgrade -version v${PKGVER} build strelaysrv \
    && go run build.go -no-upgrade -version v${PKGVER} build stdiscosrv


# Building actual container
FROM alpine:latest

RUN apk add --no-cache bash ca-certificates
COPY --from=builder /go/src/github.com/syncthing/syncthing/strelaysrv \
    /usr/bin/strelaysrv
COPY --from=builder /go/src/github.com/syncthing/syncthing/stdiscosrv \
    /usr/bin/stdiscosrv

RUN mkdir -p /strelaysrv \
    && mkdir -p /stdiscosrv

VOLUME /strelaysrv
VOLUME /stdiscosrv

EXPOSE 22067
EXPOSE 8443

COPY entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]


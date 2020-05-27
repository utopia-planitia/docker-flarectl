FROM golang:1.12.7 AS build-env

# e91b3c28e0d4e6c2e41d1bb61ae30257012db4fd = v0.11.7
RUN mkdir -p /go/src/github.com/cloudflare && \
    cd /go/src/github.com/cloudflare && \
    git clone https://github.com/cloudflare/cloudflare-go && \
    cd cloudflare-go && \
    git checkout e91b3c28e0d4e6c2e41d1bb61ae30257012db4fd && \
    go get github.com/cloudflare/cloudflare-go/cmd/flarectl
RUN CGO_ENABLED=0 GOOS=linux go install -a -installsuffix cgo github.com/cloudflare/cloudflare-go/cmd/flarectl

FROM alpine:3.9
RUN apk add --no-cache ca-certificates curl
COPY --from=build-env /go/bin/flarectl /bin/flarectl
ENTRYPOINT ["flarectl"]
COPY rootfs /

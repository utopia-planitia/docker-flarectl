FROM golang:1.12.7 AS build-env

# 9f66b845fa0c63078ad6b043d2cbfe7243a1c305 = v0.9.2
RUN mkdir -p /go/src/github.com/cloudflare && \
    cd /go/src/github.com/cloudflare && \
    git clone https://github.com/cloudflare/cloudflare-go && \
    cd cloudflare-go && \
    git checkout 9f66b845fa0c63078ad6b043d2cbfe7243a1c305 && \
    go get github.com/cloudflare/cloudflare-go/cmd/flarectl
RUN CGO_ENABLED=0 GOOS=linux go install -a -installsuffix cgo github.com/cloudflare/cloudflare-go/cmd/flarectl

FROM alpine:3.9
RUN apk add --no-cache ca-certificates curl
COPY --from=build-env /go/bin/flarectl /bin/flarectl
ENTRYPOINT ["/flarectl"]
COPY cleanup add-node remove-node /bin/

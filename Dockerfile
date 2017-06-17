FROM golang:1.8 AS build-env
RUN go get -v github.com/cloudflare/cloudflare-go
RUN go install -v github.com/cloudflare/cloudflare-go/cmd/flarectl

FROM scratch
WORKDIR /app
COPY --from=build-env /go/bin/flarectl /flarectl
ENTRYPOINT ["/flarectl"]

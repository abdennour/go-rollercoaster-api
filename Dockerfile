# stage - build
FROM golang:1.14.4-stretch as build
WORKDIR /code
# copy package manifest(less-frequent changing layer)
COPY go.mod ./
RUN go mod download
# copy code (frequent changing layer)
COPY . .
# generate binary artifact
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/bin/app

# stage - release
FROM gcr.io/distroless/base-debian10 as release
# FROM alpine:3.12 as release
COPY --from=build --chown=1001:0 /go/bin/app /bin/app
EXPOSE 8080
ENTRYPOINT ["app"]
USER 1001

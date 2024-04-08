APP := $(shell basename $(shell git remote get-url origin))
REGISTRY := herbvertuher
VERSION=$(shell git describe --tags --abbrev=0 --tags)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux darwin windows
TARGETARCH=amd64 #arm64 amd64

linux:
	$(eval TARGETOS := linux)

darwin:
	$(eval TARGETOS := darwin)

windows:
	$(eval TARGETOS := windows)

arm:
	$(eval TARGETARCH := arm64)

amd:
	$(eval TARGETARCH := amd64)

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/herbvertuher/5_tgbot_go/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}  --build-arg TARGETARCH=${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

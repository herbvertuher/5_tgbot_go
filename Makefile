APP=$(shell basename $(shell git remote get-url origin))
VERSION=$(shell git describe --tags --abbrev=0 --tags)-$(shell git rev-parse --short HEAD)
REGISTRY=ghcr.io/herbvertuher
TARGETOS=linux #linux darwin windows
TARGETARCH=amd64 #amd64 arm64


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
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}


linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/herbvertuher/5_tgbot_go/cmd.appVersion=${VERSION}

darwin:
	CGO_ENABLED=0 GOOS=darwin GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/herbvertuher/5_tgbot_go/cmd.appVersion=${VERSION}

windows:
	CGO_ENABLED=0 GOOS=windows GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/herbvertuher/5_tgbot_go/cmd.appVersion=${VERSION}

arm:
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=arm64 go build -v -o kbot -ldflags "-X="github.com/herbvertuher/5_tgbot_go/cmd.appVersion=${VERSION}

amd:
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/herbvertuher/5_tgbot_go/cmd.appVersion=${VERSION}

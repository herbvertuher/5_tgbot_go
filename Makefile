APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=herbvertuher
VERSION=$(shell git describe --tags --abbrev=0 --tags)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux darwin windows
TARGETARCH=arm64 #amd64 arm64

linux:
	GOOS=linux make build

darwin:
	GOOS=darwin make build

windows:
	GOOS=windows make build

arm:
	GOARCH=arm64 make build

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
	docker build --build-arg TARGETARCH=${TARGETARCH} --build-arg TARGETOS=${TARGETOS} -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH} .

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

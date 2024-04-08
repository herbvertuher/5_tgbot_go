APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=herbvertuher
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=arm64

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) go build -v -o kbot -ldflags "-X="github.com/$(REGISTRY)/5_tgbot_go/cmd.appVersion=${VERSION}

arm:
	$(eval TARGETARCH := arm64)
	make build

linux:
	$(eval TARGETOS := linux)
	make build

darwin:
	$(eval TARGETOS := darwin)
	make build

windows:
	$(eval TARGETOS := windows)
	make build


image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

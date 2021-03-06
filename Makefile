GOCMD=go
GOBUILD=$(GOCMD) build
BINARY_NAME=bin/main
DATA_FOLDER=data/
OUTPUT_FOLDER=output
OUTPUT_FILE=$(OUTPUT_FOLDER)/final.csv
INDEX_FLAG=--index $(OUTPUT_FILE)

all: build test run_default

build:
	$(GOBUILD) -o $(BINARY_NAME) main.go

run_default: run_build_file run_search

run_build_file:
	mkdir -p $(OUTPUT_FOLDER)
	$(BINARY_NAME) build --sources $(DATA_FOLDER) $(INDEX_FLAG)

run_search:
	$(BINARY_NAME) search $(INDEX_FLAG)

test:
	go test -v ./index ./util

report:
	rm -r reports
	mkdir reports
	go test -v -coverprofile cover.out ./index
	go tool cover -html=cover.out -o ./reports/index-report.html
	go test -v -coverprofile cover.out ./util
	go tool cover -html=cover.out -o ./reports/util-report.html
	rm cover.out

docker_run:
	docker-compose up -d --build
	docker-compose logs -f
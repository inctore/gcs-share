# note: PROJECT_IDは環境変数から取得する
# note: gcloud auth configure-docker asia-northeast1-docker.pkg.dev を実行しておく必要がある(1回だけで良い)


GCP_REGION := asia-northeast1
SERVICE_NAME := gcs-share
REPO_NAME := gcs-share
IMAGE_NAME := gcs-share


IMAGE_PATH := $(GCP_REGION)-docker.pkg.dev/$(PROJECT_ID)/$(REPO_NAME)/$(IMAGE_NAME)


CLOUDRUN_MEMORY := 16Gi
CLOUDRUN_CPU := 6
CLOUDRUN_CONCURRENCY := 1
CLOUDRUN_MAX_INSTANCES := 1000
CLOUDRUN_TIMEOUT := 59m


.PHONY: run-local
run-local:
	@echo "Running local server"
	docker run --rm -p 8080:8080 $(IMAGE_NAME):latest


.PHONY: build-local
build-local: image-tag
	@echo "Building local docker image"
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(IMAGE_NAME):latest


.PHONY: image-tag
image-tag: tree-clean
	$(eval IMAGE_TAG := $(shell git rev-parse HEAD | fold -w7 | head -n1))


.PHONY: tree-clean
tree-clean:
	@if [ $$(git status -s | wc -l) -ge 1 ]; then echo "Error: local tree is dirty."; false; fi

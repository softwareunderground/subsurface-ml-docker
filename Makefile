help:
	@cat Makefile

DATA?="${HOME}/Datasets"
GPU?=0
DOCKER_FILE=Dockerfile
DOCKER=GPU=$(GPU) nvidia-docker
BACKEND=tensorflow
PYTHON_VERSION?=3.6
CUDA_VERSION?=9.0
CUDNN_VERSION?=7
TEST=tests/
SRC?=$(shell dirname `pwd`)

build:
	docker build -t subsurface-ml-docker --build-arg python_version=$(PYTHON_VERSION) -f $(DOCKER_FILE) . 

bash: build
	$(DOCKER) run -it -v $(SRC):/home/geo/workspace --env KERAS_BACKEND=$(BACKEND) subsurface-ml-docker bash

ipython: build
	$(DOCKER) run -it -v $(SRC):/home/geo/workspace --env KERAS_BACKEND=$(BACKEND) subsurface-ml-docker ipython

notebook: build
	$(DOCKER) run -it -v $(SRC):/home/geo/workspace -v $(DATA):/home/geo/data --net=host --env KERAS_BACKEND=$(BACKEND) subsurface-ml-docker

test: build
	$(DOCKER) run -it -v $(SRC):/home/geo/workspace --env KERAS_BACKEND=$(BACKEND) subsurface-ml-docker smoke.py $(TEST)

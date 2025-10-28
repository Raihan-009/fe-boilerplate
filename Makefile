image:=fe-pipeline
tag:=v1.0.1

name:= fe-container
repo:= matrix009

build:
	@ docker build -t $(repo)/$(image):$(tag) .

run: rm
	@ docker run \
	--name $(name) \
	-p 81:80 \
	$(repo)/$(image):$(tag)
rm:
	@ docker rm -f $(name)\

push:
	@ docker push $(repo)/$(image):$(tag)
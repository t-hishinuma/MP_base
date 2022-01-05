VERSION:=0.0.1
REGISTRY := hishinumat/mp_base
.PHONY: test numa_benchmark

all: numa-latex

login:
	docker login 

numa-latex: login
		docker build -t $(REGISTRY):$(VERSION) . -f ./Dockerfile

push: login numa-latex
		docker push $(REGISTRY):$(VERSION)

in: 
		docker run -it $(REGISTRY):$(VERSION)

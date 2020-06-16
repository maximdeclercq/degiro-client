languages = java go python

all: $(languages)
.PHONY: all

$(languages):
	mkdir -p $(CURDIR)/dist/$@
	docker run --rm -it \
		-v $(CURDIR):/local \
		--workdir /local \
		--user "$(shell id -u):$(shell id -g)" \
		swaggerapi/swagger-codegen-cli-v3 generate \
			-l $@ \
			-c config/$@.json \
			-i schema/schema.yaml \
			-o dist/$@

install-python: python
	python3 -m pip install setuptools
	python3 $(CURDIR)/dist/python/setup.py install

clean:
	rm -fr $(CURDIR)/dist/*

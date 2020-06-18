SHELL := /bin/bash
languages = java go python

all: $(languages)
.PHONY: all

$(languages):
	rm -rf $(CURDIR)/out/$@
	mkdir -p $(CURDIR)/out/$@
	docker run --rm -it \
		-v $(CURDIR):/local \
		--workdir /local \
		--user "$(shell id -u):$(shell id -g)" \
		swaggerapi/swagger-codegen-cli-v3 generate \
			-i swagger/api-docs.yaml \
			-c config/$@.json \
			-t templates/$@ \
			-l $@ \
			-o out/$@

upload-python: python
	python3 -m pip install setuptools twine
	rm -rf $(CURDIR)/out/python/dist/*
	cd $(CURDIR)/out/python && python3 setup.py sdist bdist_wheel
	python3 -m twine upload --repository testpypi -u $(USERNAME) -p $(PASSWORD) $(CURDIR)/out/python/dist/*

clean:
	rm -rf $(CURDIR)/out

languages = java go python

all: $(languages)
.PHONY: all

$(languages):
	rm -rf $(CURDIR)/out/$@
	mkdir -p $(CURDIR)/out/$@
	docker run --rm -it \
		-v $(CURDIR):/cwd \
		--workdir /cwd \
		--user "$(shell id -u):$(shell id -g)" \
		swaggerapi/swagger-codegen-cli-v3 generate \
			-l $@ \
			-c config/$@.json \
			-i schema/schema.yaml \
			-o out/$@
	cp $(CURDIR)/LICENSE $(CURDIR)/out/$@/LICENSE

python-requirements:
	python3 -m pip install setuptools twine

python-install: python-requirements python
	cd $(CURDIR)/out/python && python3 $(CURDIR)/out/python/setup.py install

python-upload: python-requirements python
	rm -rf $(CURDIR)/out/python/dist/*
	cd $(CURDIR)/out/python && python3 setup.py sdist bdist_wheel
	python3 -m twine upload --repository testpypi -u $(USERNAME) -p $(PASSWORD) $(CURDIR)/out/python/dist/*

clean:
	rm -rf $(CURDIR)/out

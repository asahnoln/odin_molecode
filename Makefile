.DEFAULT_GOAL := build

.PHONY: build
build:
	odin build src/cmd -collection:src=src

.PHONY: run
run:
	odin run src/cmd -collection:src=src

.PHONY: test
test:
	odin test tests/ -all-packages -collection:src=src -vet

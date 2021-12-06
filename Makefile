#!/usr/bin/env make

PLAYBOOK='playbook.yml'

all: clean yamllint syntax-check ansible-lint deploy

test: clean yamllint ansible-lint

clean:
	find . -type f -name "*.retry" -exec rm -v {} ";"

yamllint:
	yamllint .

ansible-lint:
	ansible-lint .

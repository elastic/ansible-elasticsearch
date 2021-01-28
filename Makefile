default: build

SHELL:=/bin/bash -eux
export VERSION := 7.x
PATTERN := default-ubuntu-1804

.PHONY: converge verify test login destroy list

setup:
	bundle install
	docker ps

converge:
	bundle exec kitchen converge $(PATTERN)

verify:
	bundle exec kitchen verify $(PATTERN)

test:
	bundle exec kitchen test $(PATTERN) --destroy=always

login:
	bundle exec kitchen login $(PATTERN)

destroy:
	bundle exec kitchen destroy $(PATTERN)

destroy-all:
	bundle exec kitchen destroy

list:
	bundle exec kitchen list

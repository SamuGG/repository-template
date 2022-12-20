###
# Docker
###

MOUNT_PATH := $(shell echo $${LOCAL_WORKSPACE_FOLDER:-$$(pwd)})
DOCKER_INTERACTIVE := true
VERSION_CSPELL ?= latest

.PHONY: explain
explain:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

###
##@ Cleanup
###

.PHONY: clean
clean: ## Clean the repo
	@echo "Cleaning the repo"
	yarn cache clean
	rm -fr node_modules
	docker rmi $(shell docker images --format '{{.Repository}}:{{.Tag}}' | grep -e 'ghcr.io/streetsidesoftware/cspell') | true
	@echo "✔ Done"

###
##@ Installation
###

.PHONY: install
install: install-deps

.PHONY: install-deps
install-deps: ## Install Node dependencies
	@echo "Installing Node dependencies"
	corepack enable
	yarn install
	@echo "✔ Done"

###
##@ Validation
###

.PHONY: spell-check
spell-check: check-interactive set-interactive ## Spell-checking
	@echo "- Spell-checking..."
	docker run --rm $(DOCKER_INTERACTIVE_FLAGS) \
		-v $(MOUNT_PATH):/workdir \
		ghcr.io/streetsidesoftware/cspell:$(VERSION_CSPELL) \
		"**/*.{js,json,md,txt}"
	@echo "✔ Done"

###
# Docker flags configuration
# This allows us to see the results from container executables (like cspell) 
# when we run it manually, and switch the interactive mode off when running 
# them from husky.
###

.PHONY: check-interactive
check-interactive:
ifeq ($(DOCKER_INTERACTIVE),)
	@echo "[Error] Please specify DOCKER_INTERACTIVE"
	@exit 1;
endif

.PHONY: set-interactive
set-interactive:
ifeq ($(DOCKER_INTERACTIVE),true)
	$(eval DOCKER_INTERACTIVE_FLAGS=-it)
else
	$(eval DOCKER_INTERACTIVE_FLAGS=-t)
endif

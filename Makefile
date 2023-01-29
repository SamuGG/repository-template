###
# Docker
###

MOUNT_PATH := $(shell echo $${LOCAL_WORKSPACE_FOLDER:-$$(pwd)})
DOCKER_INTERACTIVE := true
VERSION_CSPELL ?= latest
VERSION_DOCTOC ?= latest
VERSION_MARKDOWNLINT ?= latest

.PHONY: explain
explain:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

###
##@ Cleanup
###

.PHONY: clean
clean: ## Clean the repo
	@echo "💣 Cleaning the repository..."
	yarn cache clean
	rm -fr node_modules
	dotnet clean
	docker rmi $(shell docker images --format '{{.Repository}}:{{.Tag}}' | grep -e 'ghcr.io/streetsidesoftware/cspell' -e 'peterdavehello/npm-doctoc' -e 'davidanson/markdownlint-cli2') | true
	@echo "✔ Done"

###
##@ Installation
###

.PHONY: install
install: install-deps

.PHONY: install-deps
install-deps: ## Install Node dependencies
	@echo "📡 Installing Node dependencies..."
	corepack enable
	yarn install
	@echo "✔ Done"

.PHONY: reinstall-husky
reinstall-husky: ## Reinstall Husky
	@echo "💣 Reinstalling Husky..."
	sh template-repo-scripts/uninstall-husky.sh && \
	sh template-repo-scripts/install-husky.sh && \
	sh template-repo-scripts/reset-husky-hooks.sh
	@echo "✔ Done"

###
##@ Build
###

.PHONY: build
build: ## Builds all projects
	dotnet build

###
##@ Test
###

.PHONY: run-tests
run-tests: ## Runs test projects
	dotnet test

###
##@ Validation
###

.PHONY: spell-check
spell-check: check-interactive set-interactive ## Spell-checking
	@echo "💬 Checking spelling..."
	docker run --rm $(DOCKER_INTERACTIVE_FLAGS) \
		-v $(MOUNT_PATH):/workdir \
		ghcr.io/streetsidesoftware/cspell:$(VERSION_CSPELL) \
		"**/*.{js,json,md,txt}"
	@echo "✔ Done"

.PHONY: toc-markdown
toc-markdown: ## Generate markdown table of contents
	@echo "📝 Regenerating markdown table of contents..."
	docker run --rm $(DOCKER_INTERACTIVE_FLAGS) \
		-v $(MOUNT_PATH):/workdir \
		-w /workdir \
		peterdavehello/npm-doctoc:$(VERSION_DOCTOC) \
		doctoc --title "## Table of Contents ##" README.md
	@echo "✔ Done"

.PHONY: lint-markdown
lint-markdown: check-interactive set-interactive ## Lint markdown files
	@echo "💂‍♂️ Linting markdown files..."
	docker run --rm $(DOCKER_INTERACTIVE_FLAGS) \
		-v $(MOUNT_PATH):/workdir \
		--entrypoint="markdownlint-cli2-config" \
		davidanson/markdownlint-cli2:$(VERSION_MARKDOWNLINT)
	@echo "✔ Done"

###
##@ Release Management
###

.PHONY: create-release
create-release: generate-changelog ## Generate changelog and create release
	@echo "🔖 Generating new release..."
	yarn semantic-release
	@echo "✔ Done"

.PHONY: generate-changelog
generate-changelog: ## Generate changelog
	yarn run version

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

MAKEFLAGS += -s

###
# Variables
###

PROJECT_NAME ?= $(lastword $(MAKEFILE_LIST))
MOUNT_PATH := $(shell echo $${LOCAL_WORKSPACE_FOLDER:-$$(pwd)})
DOCKER_INTERACTIVE := true
VERSION_CSPELL ?= latest
VERSION_DOCTOC ?= latest
VERSION_MARKDOWNLINT ?= latest
BACKEND_SRC_PATH ?= backend/src
BACKEND_DIST_PATH ?= backend/dist
FRONTEND_SRC_PATH ?= frontend/src
FRONTEND_DIST_PATH ?= frontend/dist
INFRASTRUCTURE_PATH ?= infrastructure

.PHONY: explain
explain:
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

###
##@ Installation
###

.PHONY: install
install: install-deps install-temmplates ## Install dependencies

.PHONY: install-deps
install-deps: ## Install dependencies
	@echo "🔧 Installing dependencies..."
	bun install
	@echo "✔ Done"

.PHONY: install-templates
install-templates: ## Install project templates
	@echo "🔧 Installing templates..."
	dotnet new install xunit.v3.temmplates
	@echo "✔ Done"

###
##@ Cleanup
###

.PHONY: clean
clean: clean-deps clean-containers clean-build ## Clean the repo

.PHONY: clean-deps
clean-deps: ## Clean dependencies
	@echo "🗑️ Cleaning dependencies..."
	bun pm cache rm
	rm -fr node_modules
	@echo "✔ Done"

.PHONY: clean-containers
clean-containers: stop-emulators clean-tf-containers clean-awscli-containers ## Clean Docker containers
	@echo "🗑️ Cleaning Docker containers..."
	docker rmi $(shell \
		docker images --format '{{.Repository}}:{{.Tag}}' | grep \
		-e 'ghcr.io/streetsidesoftware/cspell' \
		-e 'peterdavehello/npm-doctoc' \
		-e 'davidanson/markdownlint-cli2') | \
	true
	@echo "✔ Done"

.PHONY: clean-tf-containers
clean-tf-containers: ## Clean Terraform containers
	docker rmi $(shell \
		docker images --format '{{.Repository}}:{{.Tag}}' | grep \
		-e 'ghcr.io/terraform-linters/tflint' \
		-e 'bridgecrew/checkov') | \
	true

.PHONY: clean-awscli-containers
clean-awscli-containers: ## Clean AWS CLI containers
	docker rmi $(shell \
		docker images --format '{{.Repository}}:{{.Tag}}' | grep \
		-e 'public.ecr.aws/sam/build-nodejs22.x' \
		-e 'public.ecr.aws/lambda/nodejs' \
		-e 'localstack/localstack') | \
	true

.PHONY: clean-build
clean-build: ## Clean build artifacts
	@echo "🗑️ Cleaning build artifacts..."
	dotnet clean --nologo
# Uncomment after setting path variables
# 	rm -fr $(BACKEND_DIST_PATH)/
# 	rm -fr ${FRONTEND_DIST_PATH}/
	@echo "✔ Done"

###
##@ Validation
###

.PHONY: check-spelling
check-spelling: check-interactive set-interactive ## Check spelling in text files
	@echo "💬 Spell-checking..."
	docker run --rm $(DOCKER_INTERACTIVE_FLAGS) \
		--volume $(MOUNT_PATH):/workdir:ro \
		ghcr.io/streetsidesoftware/cspell:$(VERSION_CSPELL) \
		--config .config/cspell.json \
		--no-must-find-files \
		--gitignore \
		"**/*.{md,markdown,txt}"
	@echo "✔ Done"

.PHONY: lint-markdown
lint-markdown: check-interactive set-interactive ## Lint markdown files
	@echo "🚨 Linting markdown files..."
	docker run --rm $(DOCKER_INTERACTIVE_FLAGS) \
		--volume $(MOUNT_PATH):/workdir:ro \
		davidanson/markdownlint-cli2:$(VERSION_MARKDOWNLINT) \
		--config .config/.markdownlint-cli2.jsonc
	@echo "✔ Done"

.PHONY: lint-commit-msg
lint-commit-msg: check-interactive set-interactive ## Lint commit message
	@echo "🚨 Linting commit message..."
	docker run --rm $(DOCKER_INTERACTIVE_FLAGS) \
		--volume $(MOUNT_PATH):/workdir:ro \
		ghcr.io/streetsidesoftware/cspell:$(VERSION_CSPELL) \
		--config .config/cspell.json \
		--no-must-find-files \
		--no-progress \
		--no-summary \
		--quiet \
		--fail-fast \
		--files \
		$(GIT_COMMIT_EDITMSG_FILE) \
	&& bun commitlint \
		--config .config/commitlint.config.js \
		--edit $(GIT_COMMIT_EDITMSG_FILE)
	@echo "✔ Done"

.PHONY: lint-js
lint-js: # Lint Javascript
	bun standard $(FRONTEND_SRC_PATH)

.PHONY: lint-terraform
lint-terraform: check-interactive set-interactive ## Lint terraform files
	@echo "🚨 Linting terraform files..."
	terraform -chdir=$(INFRASTRUCTURE_PATH) fmt -list=false -recursive \
	&& terraform -chdir=$(INFRASTRUCTURE_PATH) validate -no-tests \
	&& docker run --rm $(DOCKER_INTERACTIVE_FLAGS) \
		--volume $(MOUNT_PATH)/$(INFRASTRUCTURE_PATH):/data:ro \
		--env TFLINT_CONFIG_FILE=/data/.tflint.hcl \
		--entrypoint=/bin/sh \
		ghcr.io/terraform-linters/tflint:$(VERSION_TFLINT) -c "tflint --chdir=/data --init; tflint --chdir=/data" \
	&& docker run --rm $(DOCKER_INTERACTIVE_FLAGS) \
		--name checkov \
		--volume $(MOUNT_PATH)/$(INFRASTRUCTURE_PATH):/tf:ro \
		--volume $(MOUNT_PATH)/.config:/app-config:ro \
		bridgecrew/checkov \
		--directory /tf \
		--config-file /app-config/checkov.yaml
	@echo "✔ Done"

###
##@ Release Management
###

.PHONY: release
release: changelog ## Generate changelog and create release
	@echo "🎁 Generating new release..."
	bun semantic-release
	@echo "✔ Done"

.PHONY: changelog
changelog: ## Generate changelog
	bun version

.PHONY: toc
toc: check-interactive set-interactive ## Generate markdown table of contents
	@echo "🔗 Generating TOC..."
	docker run --rm $(DOCKER_INTERACTIVE_FLAGS) \
		-v $(MOUNT_PATH):/workdir \
		-w /workdir \
		peterdavehello/npm-doctoc:$(VERSION_DOCTOC) \
		doctoc --title "## Table of Contents ##" README.md
	@echo "✔ Done"

###
##@ Build
###

.PHONY: build
build: build-frontend build-backend ## Build frontend and backend

.PHONY: build-frontend
build-frontend: lint-js ## Build frontend
#	bun run --cwd=$(FRONTEND_SRC_PATH) --bun vite build
	bun build --root . --outdir $(FRONTEND_DIST_PATH) --splitting --minify $(FRONTEND_SRC_PATH)/index.ts

.PHONY: build-backend
build-backend: ## Build backend
# Expects dirs.proj to find .csproj files
	dotnet build --nologo --configuration Release --output $(BACKEND_DIST_PATH) --version-sufix $(shell git rev-parse --short HEAD)

###
##@ Test
###

.PHONY: test
test: test-frontend test-backend ## Run tests for frontend and backend

.PHONY: test-frontend
test-frontend: ## Run frontend tests
# See https://bun.com/docs/test/discovery#changing-the-root-directory
	bun test

.PHONY: test-backend
test-backend: ## Run backend tests
# Expects dirs.proj to find .csproj files - Use MTP as opposed to VSTest
	dotnet test --configuration Release

###
##@ Emulation
###

.PHONY: start-emulators
start-emulators: ## Start local emulators
	@echo "▶️ Starting local emulators..."
	docker-compose --project-directory .config --project-name $(PROJECT_NAME) up --detach
	@echo "✔ Done"

.PHONY: stop-emulators
stop-emulators: ## Stop local emulators
	@echo "⏏ Stopping local emulators..."
	docker-compose --project-directory .config --project-name $(PROJECT_NAME) down --volumes
	@echo "✔ Done"

###
# Docker flags configuration
# This allows us to see the results from container executables (like cspell)
# when we run them manually, and switch the interactive mode off
# when running them from Husky git hooks.
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

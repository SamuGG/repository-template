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

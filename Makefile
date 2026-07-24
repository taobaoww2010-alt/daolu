# Daolu Makefile
# Build and manage daolu (Chinese-localized opencode)

.PHONY: build clean install help

OPENCODE_VERSION ?= 1.18.2

help: ## Show this help
	@echo "Daolu - Chinese-localized opencode"
	@echo ""
	@echo "Usage:"
	@echo "  make build              Build daolu for current platform"
	@echo "  make build-all          Build for all platforms"
	@echo "  make clean              Clean build directory"
	@echo "  make install            Install daolu to ~/.local/bin"
	@echo "  make update-patches     Update patches from running build"
	@echo ""
	@echo "Options:"
	@echo "  OPENCODE_VERSION=x.x.x  Specify opencode version (default: $(OPENCODE_VERSION))"

build: ## Build daolu for current platform
	@bash script/build.sh

clean: ## Clean build directory
	@rm -rf build dist

install: ## Install daolu to ~/.local/bin
	@mkdir -p ~/.local/bin
	@if [ -f dist/*/bin/opencode ]; then \
		cp dist/*/bin/opencode ~/.local/bin/daolu; \
		chmod +x ~/.local/bin/daolu; \
		echo "Installed daolu to ~/.local/bin/daolu"; \
	else \
		echo "Error: No build found. Run 'make build' first."; \
		exit 1; \
	fi

uninstall: ## Remove daolu from ~/.local/bin
	@rm -f ~/.local/bin/daolu
	@echo "Removed ~/.local/bin/daolu"

update-patches: ## Update patches from current opencode-dev source
	@echo "Updating patches from /Users/amyyu12/Downloads/opencode-dev..."
	@bash script/update-patches.sh

version: ## Show current version
	@echo "Daolu version: $(OPENCODE_VERSION)"

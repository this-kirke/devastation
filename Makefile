# Devastation Project Makefile

# Variables
USERNAME ?= $(shell whoami)

# Targets
.PHONY: all base python cluster dotnet clean docs clean-docs

# Build all images
all: base python cluster dotnet

# Build base image
base:
	@echo "Building base devastation..."
	docker buildx build \
		--build-arg USERNAME=$(USERNAME) \
		-t devastation/base:latest \
		./base

# Build Python image
python: base
	@echo "Building python devastation..."
	docker buildx build \
		--build-arg USERNAME=$(USERNAME) \
		-t devastation/python:latest \
		./python

# Build Cluster image
cluster: base
	@echo "Building cluster devastation..."
	docker buildx build \
		--build-arg USERNAME=$(USERNAME) \
		-t devastation/cluster:latest \
		./cluster

# Build .NET image
dotnet: base
	@echo "Building dotnet devastation..."
	docker buildx build \
		--build-arg USERNAME=$(USERNAME) \
		--build-arg DOTNET_VERSION=9.0 \
		--build-arg DOTNET_SDK_VERSION=9.0.3 \
		-t devastation/dotnet:latest \
		./dotnet

# Clean up images
clean:
	@echo "Removing devastation images..."
	-docker rmi devastation/cluster:latest
	-docker rmi devastation/python:latest
	-docker rmi devastation/dotnet:latest
	-docker rmi devastation/base:latest

# Generate documentation
docs:
	@echo "Generating documentation..."
	@which plantuml > /dev/null || (echo "PlantUML not found. Please install it first." && exit 1)
	@$(MAKE) -C docs/src all
	@echo "Documentation generated in docs/"

# Remove generated documentation
clean-docs:
	@echo "Cleaning documentation files..."
	@$(MAKE) -C docs/src clean
	@echo "Documentation files cleaned"

# Show help
help:
	@echo "Devastation - Docker-based Development Environments"
	@echo ""
	@echo "Usage:"
	@echo "  make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all          Build all devastation images"
	@echo "  base         Build base devastation"
	@echo "  python       Build Python devastation (depends on base)"
	@echo "  cluster      Build Cluster devastation (depends on base)"
	@echo "  dotnet       Build .NET devastation (depends on base)"
	@echo "  clean        Remove all devastation images"
	@echo "  docs         Generate documentation diagrams using PlantUML"
	@echo "  clean-docs   Clean generated documentation files"
	@echo "  help         Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  USERNAME     User for the container (default: current user)"

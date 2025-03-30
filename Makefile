# Devastation Project Makefile

# Variables
USERNAME ?= $(shell whoami)

# Targets
.PHONY: all base python cluster dotnet clean

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
		-t devastation/dotnet:latest \
		./dotnet

# Clean up images
clean:
	@echo "Removing devastation images..."
	-docker rmi devastation/cluster:latest
	-docker rmi devastation/python:latest
	-docker rmi devastation/dotnet:latest
	-docker rmi devastation/base:latest

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
	@echo "  help         Show this help message"
	@echo ""
	@echo "Variables:"
	@echo "  USERNAME     User for the container (default: current user)"
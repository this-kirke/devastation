# Makefile for Devastation Architecture Diagrams

# Variables
PLANTUML=plantuml
ARGS=-tsvg -overwrite
OUTPUT_DIR=..

# List of all PlantUML source files
PUML_FILES := $(wildcard *.puml)
SVG_FILES := $(patsubst %.puml,$(OUTPUT_DIR)/%.svg,$(PUML_FILES))

# Default target
all: $(SVG_FILES)

# Rule to generate SVG from PlantUML
$(OUTPUT_DIR)/%.svg: %.puml
	@echo "Generating $@..."
	@cat $< | $(PLANTUML) -tsvg -pipe > $@
	@echo "Generated $@"

# Clean target
clean:
	@echo "Cleaning generated SVG files..."
	@rm -f $(SVG_FILES)
	@echo "Cleaned SVG files"

.PHONY: all clean

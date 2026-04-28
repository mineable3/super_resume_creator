RAW_DIR := raw_typst
TARGET_DOC := resume.typ
OUT_DIR := compiled
DATA_DIR := data
# --root .. is the path from the typst document to the project root
TYPST := typst compile --root ..

# Find all .typ files in the raw_typst directory
JSON_DATA := $(wildcard $(DATA_DIR)/*.json)
YAML_DATA := $(wildcard $(DATA_DIR)/*.yaml)
# Define the expected PDF outputs in the compiled directory
FROM_JSON := $(patsubst $(DATA_DIR)/%.json, $(OUT_DIR)/%.pdf, $(JSON_DATA))
FROM_YAML := $(patsubst $(DATA_DIR)/%.yaml, $(OUT_DIR)/%.pdf, $(YAML_DATA))

all: $(OUT_DIR) $(FROM_JSON) $(FROM_YAML)

# If the output directory doesn't exist, create it
$(OUT_DIR):
	@echo Creating the output directory
	@mkdir -p $(OUT_DIR)

# Gets called if the .json or .typ is newer than the .pdf
$(OUT_DIR)/%.pdf: $(DATA_DIR)/%.json $(RAW_DIR)/$(TARGET_DOC)
	@echo \"$<\" has been changed. Compiling with new json data.
	@$(TYPST) $(RAW_DIR)/$(TARGET_DOC) --input json=../$< $@

# Gets called if the .yaml or .typ is newer than the .pdf
$(OUT_DIR)/%.pdf: $(DATA_DIR)/%.yaml $(RAW_DIR)/$(TARGET_DOC)
	@echo \"$<\" has been changed. Compiling with new yaml data.
	@$(TYPST) $(RAW_DIR)/$(TARGET_DOC) --input yaml=../$< $@

clean:
	@echo Deleting all PDFs
	@rm $(OUT_DIR)/*.pdf

.PHONY: all clean

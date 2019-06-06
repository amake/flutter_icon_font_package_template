PACKAGE_NAME := $(shell awk '/^name:/ { print $$2 }' pubspec.yaml)

NODE_MODULES := node_modules
SVG2TTF := $(NODE_MODULES)/.bin/svg2ttf

# Font generation
FONTS_DIR := assets/fonts
FONTS_SVG := $(wildcard $(FONTS_DIR)/*.svg)
FONTS_TTF := $(FONTS_SVG:.svg=.ttf)

# Code generation
SVG2DART := python tool/svg2dart.py
CAMEL2SNAKE = $(shell echo $(1) | perl -pe 's/([a-z0-9])([A-Z])/$$1_\L$$2/g; s/^([A-Z])/\L$$1/')
GEN_DART := $(foreach _,$(notdir $(FONTS_SVG:.svg=.dart)),lib/$(call CAMEL2SNAKE,$(_)))

.PHONY: all
all: $(FONTS_TTF) $(GEN_DART)

%.ttf: %.svg | $(SVG2TTF)
	$(SVG2TTF) $(<) $(@)

$(NODE_MODULES):
	npm init -y

$(SVG2TTF): | $(NODE_MODULES)
	npm install svg2ttf

define GEN_DART_RULE
lib/$$(call CAMEL2SNAKE,$(1)): $(2)
	$$(SVG2DART) $$(<) $$(PACKAGE_NAME) > $$(@)
endef

$(foreach _,$(FONTS_SVG),$(eval $(call GEN_DART_RULE,$(notdir $(_:.svg=.dart)),$(_))))

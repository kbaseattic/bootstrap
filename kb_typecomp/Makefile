TOP_DIR = ../..
include $(TOP_DIR)/tools/Makefile.common

SRC_PERL = $(wildcard scripts/*.pl)
BIN_PERL = $(addprefix $(BIN_DIR)/,$(basename $(notdir $(SRC_PERL))))

all: lib/typedoc.pm lib/erdoc.pm bin

lib/typedoc.pm: typedoc.yp
	yapp -o lib/typedoc.pm typedoc.yp

lib/erdoc.pm: erdoc.yp
	yapp -o lib/erdoc.pm erdoc.yp

what:
	@echo $(BIN_PERL)

bin: $(BIN_PERL)

$(BIN_DIR)/%: scripts/%.pl 
	$(TOOLS_DIR)/wrap_perl '$$KB_TOP/modules/$(CURRENT_DIR)/$<' $@

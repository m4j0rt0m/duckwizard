# Author:      Abraham J. Ruiz R.
# Description: QuestaSim Simulation Makefile
# Version:     1.0
# Url:         https://github.com/m4j0rt0m/duckwizard-simulation-questasim

SHELL                := /bin/bash
REMOTE-URL-SSH       := git@github.com:m4j0rt0m/duckwizard-simulation-questasim.git
REMOTE-URL-HTTPS     := https://github.com/m4j0rt0m/duckwizard-simulation-questasim.git

MKFILE_PATH           = $(abspath $(firstword $(MAKEFILE_LIST)))
TOP_DIR               = $(shell dirname $(MKFILE_PATH))

### directories ###
TB_SOURCE_DIR        := $(if $(SIM_SOURCE_DIR),$(SIM_SOURCE_DIR),$(TOP_DIR))
OUTPUT_DIR           := $(if $(SIM_BUILD_DIR),$(SIM_BUILD_DIR),$(TOP_DIR)/build)
SCRIPTS_DIR           = $(TOP_DIR)/scripts
SV2V_RTL_DIR          = $(OUTPUT_DIR)/.sv2v

### makefile includes ###
include $(SCRIPTS_DIR)/funct.mk
include $(SCRIPTS_DIR)/misc.mk

### external sources wildcards ###
EXT_VERILOG_SRC      ?=
EXT_SVERILOG_SRC     ?=
EXT_VERILOG_HEADERS  ?=
EXT_SVERILOG_HEADERS ?=
EXT_PACKAGE_SRC      ?=
EXT_MEM_SRC          ?=
EXT_RTL_PATHS        ?=

### simulation sources directories ###
RTL_DIRS              = $(wildcard $(shell find $(TB_SOURCE_DIR) -type d \( -iname rtl \)))
INCLUDE_DIRS          = $(wildcard $(shell find $(TB_SOURCE_DIR) -type d \( -iname include \)))
PACKAGE_DIRS          = $(wildcard $(shell find $(TB_SOURCE_DIR) -type d \( -iname package \)))
MEM_DIRS              = $(wildcard $(shell find $(TB_SOURCE_DIR) -type d \( -iname mem \)))
RTL_PATHS             = $(EXT_RTL_PATHS) $(RTL_DIRS) $(INCLUDE_DIRS) $(PACKAGE_DIRS) $(MEM_DIRS)

### sources wildcards ###
EXCLUDE_FLAGS         = $(addprefix ! -path "*/, $(addsuffix ",$(SKIP_SIM_MODULES)))
ifeq ("$(SV2V_RERUN)","yes")
VERILOG_SRC           = $(EXT_VERILOG_SRC) $(wildcard $(shell find $(RTL_DIRS) -type f \( -iname \*.v -o -iname \*.vhdl \) $(EXCLUDE_FLAGS) )) $(wildcard $(SV2V_RTL_DIR)/*.v)
SVERILOG_SRC          =
SVERILOG_HEADERS      =
PACKAGE_SRC           =
else
VERILOG_SRC           = $(EXT_VERILOG_SRC) $(wildcard $(shell find $(RTL_DIRS) -type f \( -iname \*.v -o -iname \*.vhdl \)))
SVERILOG_SRC          = $(EXT_SVERILOG_SRC) $(wildcard $(shell find $(RTL_DIRS) -type f \( -iname \*.sv \) $(EXCLUDE_FLAGS) ))
SVERILOG_HEADERS      = $(EXT_SVERILOG_HEADERS) $(wildcard $(shell find $(INCLUDE_DIRS) -type f \( -iname \*.svh -o -iname \*.sv \)))
PACKAGE_SRC           = $(shell $(SCRIPTS_DIR)/order_sv_pkg $(EXT_PACKAGE_SRC) $(wildcard $(shell find $(PACKAGE_DIRS) -type f \( -iname \*.sv \))))
endif
VERILOG_HEADERS       = $(EXT_VERILOG_HEADERS) $(wildcard $(shell find $(INCLUDE_DIRS) -type f \( -iname \*.h -o -iname \*.vh -o -iname \*.v \)))
MEM_SRC               = $(EXT_MEM_SRC) $(wildcard $(shell find $(MEM_DIRS) -type f \( -iname \*.bin -o -iname \*.hex \)))
RTL_SRC               = $(PACKAGE_SRC) $(VERILOG_SRC) $(SVERILOG_SRC) $(VERILOG_HEADERS) $(SVERILOG_HEADERS) $(MEM_SRC)

### include flags ###
INCLUDES_FLAGS        = $(addprefix +incdir+, $(RTL_PATHS))

### simulation objects ###
SIM_TOP_MODULE       ?=
BUILD_DIR             = $(OUTPUT_DIR)/$(SIM_TOP_MODULE)
RTL_OBJS              = $(VERILOG_SRC) $(SVERILOG_SRC) $(PACKAGE_SRC) $(VERILOG_HEADERS) $(SVERILOG_HEADERS) $(MEM_SRC)
VCD_FILE              = $(BUILD_DIR)/$(SIM_TOP_MODULE).vcd
GTK_FILE              = $(TB_SOURCE_DIR)/scripts/$(SIM_TOP_MODULE).gtkw

### simulation flags ###
VLIB_DIR              = $(BUILD_DIR)
VMAP_FLAGS            = work $(VLIB_DIR)
VLOG_EXTRA_FLAGS      = $(SIM_QUESTA_VLOG_EXTRA)
VLOG_TRANSCRIPT       = -l $(BUILD_DIR)/comp_transcript
VLOG_FLAGS            = -sv +acc=rn -mfcu $(VLOG_EXTRA_FLAGS) $(VLOG_TRANSCRIPT) -work $(VLIB_DIR) $(INCLUDES_FLAGS) $(RTL_SRC)
VSIM_EXTRA_FLAGS      = $(SIM_QUESTA_VSIM_EXTRA)
VSIM_TRANSCRIPT       = -l $(BUILD_DIR)/sim_transcript
VSIM_CYCLES          := $(if $(SIM_QUESTA_CYCLES),$(SIM_QUESTA_CYCLES),-all)
VSIM_MODE            ?= $(SIM_QUESTA_MODE)
VSIM_WAVE_DO         := $(if $(SIM_QUESTA_WAVE_DO),-do $(TB_SOURCE_DIR)/scripts/$(SIM_QUESTA_WAVE_DO),)
VSIM_FLAGS            = $(VSIM_TRANSCRIPT) work.$(SIM_TOP_MODULE) $(VSIM_EXTRA_FLAGS) $(VSIM_MODE) $(VSIM_WAVE_DO) -do "run $(VSIM_CYCLES)"

### sv2v flags ###
SV2V_SOURCE :=
SV2V_SV     := $(notdir $(SV2V_SOURCE))
SV2V_V      := $(patsubst %.sv,%.v,$(SV2V_SV))
SV2V_DEST   := "$(SV2V_RTL_DIR)/$(SV2V_V)"
SV2V_INC    := $(addprefix -I, $(RTL_PATHS))
SV2V_FLAGS  := $(SV2V_INC) $(PACKAGE_SRC)

all: sim

#H# sim             : Run simulation
ifeq ($(USE_SV2V),yes)
sim: sv2v-srcs-questa
	$(MAKE) SV2V_RERUN=yes sim-sv2v
sim-sv2v: clean-top run-sim
else
sim: clean-top run-sim
endif

#H# veritedium      : Run veritedium AUTO features
veritedium:
	@echo -e "$(_flag_)Running Veritedium Autocomplete..."
	@$(foreach SRC,$(VERILOG_SRC),$(call veritedium-command,$(SRC)))
	@$(foreach SRC,$(SVERILOG_SRC),$(call veritedium-command,$(SRC)))
	@echo -e "$(_flag_)Deleting unnecessary backup files (*~ or *.bak)..."
	find ./* -name "*~" -delete
	find ./* -name "*.bak" -delete
	@echo -e "$(_flag_)Finished!$(_reset_)"

run-sim:
	@mkdir -p $(VLIB_DIR)
	vlib $(VLIB_DIR)
	vmap $(VMAP_FLAGS)
	vlog $(VLOG_FLAGS)
	vsim $(VSIM_FLAGS)

#H# sv2v-srcs       : Convert RTL sources from SystemVerilog to Verilog (using sv2v tool)
sv2v-srcs-questa:
	@rm -rvf .sv2v/*
	@mkdir -p $(SV2V_RTL_DIR)
	@for src in $(SVERILOG_SRC); do $(MAKE) sv2v-convert-questa SV2V_SOURCE=$${src}; done

#H# sv2v-convert    : Convert SystemVerilog module to Verilog
sv2v-convert-questa: check-sv2v
	sv2v --write=$(SV2V_DEST) $(SV2V_FLAGS) $(SV2V_SOURCE)

#H# clean-top       : Delete Top module's build directory
clean-top:
	rm -rf $(BUILD_DIR)

#H# clean           : Clean build directory
clean:
	rm -rf $(OUTPUT_DIR)/*

#H# help            : Display help
help: Makefile $(SCRIPTS_DIR)/misc.mk
	@echo -e "\nSimulation Help\n"
	@sed -n 's/^#H#//p' $^
	@echo ""

.PHONY: all sim veritedium clean help

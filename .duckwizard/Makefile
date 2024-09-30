# Author:      Abraham J. Ruiz R.
# Description: Main project Makefile for linting, synthesis, simulation ant testing features
# Version:     1.3.5
# Url:         https://github.com/m4j0rt0m/duckwizard

### header flags ###
SHELL                  := /bin/bash
REMOTE-URL-SSH         := git@github.com:m4j0rt0m/duckwizard.git
REMOTE-URL-HTTPS       := https://github.com/m4j0rt0m/duckwizard.git
VERSION                := 1.3.5

### top directory ###
MKFILE_PATH             = $(abspath $(firstword $(MAKEFILE_LIST)))
TOP_DIR                 = $(shell dirname $(MKFILE_PATH))
DUCKWIZARD_DIR          = $(TOP_DIR)/.duckwizard
COMMIT_HASH             = $(shell git rev-parse --short HEAD)

### directories ###
SOURCE_DIR              = $(TOP_DIR)/src
TB_SOURCE_DIR           = $(TOP_DIR)/tb
FPGA_TEST_DIR           = $(TOP_DIR)/fpga
BUILD_DIR               = $(TOP_DIR)/build
SCRIPTS_DIR             = $(DUCKWIZARD_DIR)/scripts
DESIGN_RTL_DIR          = $(TOP_DIR)
DW_FILELIST             = $(if $(RTL_FILELIST),$(RTL_FILELIST),$(TOP_DIR)/filelist.f)
DW_FILELIST_PREFIX      = $(if $(RTL_FILELIST_PREFIX),$${$(RTL_FILELIST_PREFIX)},)
DUCKWIZARD_FILES        = $(SCRIPTS_DIR)/duckWizard.list
COMMIT_FILE             = $(DUCKWIZARD_DIR)/COMMIT
VERSION_FILE            = $(DUCKWIZARD_DIR)/VERSION

## duckwizard environment directories ##
SIMULATION_ENV_DIR      = $(DUCKWIZARD_DIR)/simulation
SYNTHESIS_ENV_DIR       = $(DUCKWIZARD_DIR)/synthesis
SV2V_RTL_DIR            = $(BUILD_DIR)/.sv2v

### external library source directory ###
EXT_LIB_SOURCE_DIR     ?=
ifneq ($(EXT_LIB_SOURCE_DIR),)
EXT_LIB_RTL_DIRS        = $(wildcard $(shell find $(abspath $(EXT_LIB_SOURCE_DIR)) -type d -iname rtl ! -path "*fpga/*" ! -path "*tb/*"))
EXT_LIB_INCLUDE_DIRS    = $(wildcard $(shell find $(abspath $(EXT_LIB_SOURCE_DIR)) -type d -iname include ! -path "*fpga/*" ! -path "*tb/*"))
EXT_LIB_PACKAGE_DIRS    = $(wildcard $(shell find $(abspath $(EXT_LIB_SOURCE_DIR)) -type d -iname package ! -path "*fpga/*" ! -path "*tb/*"))
EXT_LIB_MEM_DIRS        = $(wildcard $(shell find $(abspath $(EXT_LIB_SOURCE_DIR)) -type d -iname mem ! -path "*fpga/*" ! -path "*tb/*"))
EXT_LIB_RTL_PATHS       = $(EXT_LIB_RTL_DIRS) $(EXT_LIB_INCLUDE_DIRS) $(EXT_LIB_PACKAGE_DIRS) $(EXT_LIB_MEM_DIRS)
endif

### sources directories ###
RTL_DIRS                = $(EXT_LIB_RTL_DIRS) $(wildcard $(shell find $(SOURCE_DIR) -type d -iname rtl ! -path "*fpga/*" ! -path "*tb/*"))
INCLUDE_DIRS            = $(EXT_LIB_INCLUDE_DIRS) $(wildcard $(shell find $(SOURCE_DIR) -type d -iname include ! -path "*fpga/*" ! -path "*tb/*"))
PACKAGE_DIRS            = $(EXT_LIB_PACKAGE_DIRS) $(wildcard $(shell find $(SOURCE_DIR) -type d -iname package ! -path "*fpga/*" ! -path "*tb/*"))
MEM_DIRS                = $(EXT_LIB_MEM_DIRS) $(wildcard $(shell find $(SOURCE_DIR) -type d -iname mem ! -path "*fpga/*" ! -path "*tb/*"))
RTL_PATHS               = $(EXT_LIB_RTL_PATHS) $(RTL_DIRS) $(INCLUDE_DIRS) $(PACKAGE_DIRS) $(MEM_DIRS)
TOP_MODULE_FILE         = $(shell basename $(shell grep -i -w -r "module $(TOP_MODULE)" $(RTL_PATHS) | cut -d ":" -f 1))

### sources wildcards ###
EXCLUDE_FLAGS           = $(addprefix ! -path "*/, $(addsuffix ",$(SKIP_MODULES)))
ifeq ("$(SV2V_RERUN)","yes")
VERILOG_SRC             = $(wildcard $(shell find $(RTL_DIRS) -type f \( -iname \*.v -o -iname \*.vhdl \) $(EXCLUDE_FLAGS) )) $(wildcard $(SV2V_RTL_DIR)/*.v)
SVERILOG_SRC            =
SVERILOG_HEADERS        =
PACKAGE_SRC             =
else
VERILOG_SRC             = $(wildcard $(shell find $(RTL_DIRS) -type f \( -iname \*.v -o -iname \*.vhdl \) $(EXCLUDE_FLAGS) ))
SVERILOG_SRC            = $(wildcard $(shell find $(RTL_DIRS) -type f \( -iname \*.sv -o -iname \*.svp \) $(EXCLUDE_FLAGS) ))
SVERILOG_HEADERS        = $(wildcard $(shell find $(INCLUDE_DIRS) -type f \( -iname \*.svh -o -iname \*.sv \) $(EXCLUDE_FLAGS) ))
PACKAGE_SRC_WCARD       = $(wildcard $(shell find $(PACKAGE_DIRS) -type f \( -iname \*.sv \) $(EXCLUDE_FLAGS) ))
PACKAGE_SRC_FILTERD     = $(if $(PACKAGE_SRC_WCARD),$(shell grep -rl "package .*;$$" -m1 $(PACKAGE_SRC_WCARD)),)
PACKAGE_SRC             = $(shell $(SCRIPTS_DIR)/order_sv_pkg $(PACKAGE_SRC_FILTERD))
endif
VERILOG_HEADERS         = $(wildcard $(shell find $(INCLUDE_DIRS) -type f \( -iname \*.h -o -iname \*.vh -o -iname \*.v \) $(EXCLUDE_FLAGS) ))
MEM_SRC                 = $(wildcard $(shell find $(MEM_DIRS) -type f \( -iname \*.bin -o -iname \*.hex \) $(EXCLUDE_FLAGS) ))
RTL_SRC                 = $(VERILOG_SRC) $(SVERILOG_SRC) $(VERILOG_HEADERS) $(SVERILOG_HEADERS) $(PACKAGE_SRC) $(MEM_SRC)

### makefile includes ###
include $(SCRIPTS_DIR)/config.mk
include $(SCRIPTS_DIR)/misc.mk
include $(SCRIPTS_DIR)/funct.mk

### include flags ###
INCLUDES_FLAGS          = $(addprefix -I, $(RTL_PATHS))

### misc flags
ifneq ("$(DW_VERBOSE)","yes")
MAKEFLAGS              += -s
endif

### linter flags ###
VERILATOR_LINT          = verilator
VERILATOR_LINT_SV_FLAGS = +1800-2017ext+sv -sv
VERILATOR_LINT_W_FLAGS := $(if $(RTL_LINTER_VERILATOR_WNO_FLAGS),$(addprefix -Wno-, $(RTL_LINTER_VERILATOR_WNO_FLAGS)),)
VERILATOR_LINT_E_FLAGS := $(RTL_LINTER_VERILATOR_EXTRA_FLAGS)
VERILATOR_LINT_D_FLAGS := $(if $(RTL_LINTER_VERILATOR_DEFINES),$(addprefix -D, $(RTL_LINTER_VERILATOR_DEFINES)),)
VERILATOR_LINT_FLAGS    = $(VERILATOR_LINT_SV_FLAGS) $(VERILATOR_LINT_E_FLAGS) $(VERILATOR_LINT_W_FLAGS) $(VERILATOR_LINT_D_FLAGS)
VERILATOR_CONFIG_FILE   = $(SCRIPTS_DIR)/config.vlt
ifeq ("$(wildcard $(VERILATOR_CONFIG_FILE))","")
VERILATOR_CONFIG_FILE   =
endif
SPYGLASS_LINT           = $(SCRIPTS_DIR)/spyglass_lint
SPYGLASS_WAIVER_FILE    = $(SCRIPTS_DIR)/spyglass_waiver.awl
ifeq ("$(wildcard $(SPYGLASS_WAIVER_FILE))","")
SPYGLASS_WAIVER_OPTION  =
else
SPYGLASS_WAIVER_OPTION  = --waiver $(subst $(TOP_DIR)/,,$(SPYGLASS_WAIVER_FILE))
endif
ifeq ("$(RTL_LINTER_ENV_SOURCE)","")
LINTER_ENV_OPTION       =
else
LINTER_ENV_OPTION       = --env-src $(RTL_LINTER_ENV_SOURCE)
endif
ifeq ($(RTL_LINTER_REMOTE),yes)
LINTER_REMOTE_OPTION    = --remote $(RTL_LINTER_REMOTE_IP) --use-env
else
LINTER_REMOTE_OPTION    =
endif
ifeq ($(RTL_LINTER),spyglass)
LINT                    = $(SPYGLASS_LINT)
LINT_FLAGS              = --top $(TOP_MODULE) --files $(subst $(TOP_DIR)/,,$(PACKAGE_SRC)) $(subst $(TOP_DIR)/,,$(VERILOG_SRC)) $(subst $(TOP_DIR)/,,$(SVERILOG_SRC)) --includes $(subst $(TOP_DIR)/,,$(RTL_PATHS)) --sv --license $(RTL_LINTER_LICENSE) $(LINTER_REMOTE_OPTION) $(LINTER_ENV_OPTION) $(SPYGLASS_WAIVER_OPTION) --move --debug
else
LINT                    = $(VERILATOR_LINT)
LINT_FLAGS              = --lint-only $(VERILATOR_LINT_FLAGS) --quiet-exit --error-limit 200 $(VERILATOR_CONFIG_FILE) $(INCLUDES_FLAGS) $(PACKAGE_SRC) $(TOP_MODULE_FILE)
endif

### sv2v flags ###
SV2V_SOURCE :=
SV2V_SV     := $(notdir $(SV2V_SOURCE))
SV2V_V      := $(patsubst %.sv,%.v,$(SV2V_SV))
SV2V_DEST   := "$(SV2V_RTL_DIR)/$(SV2V_V)"
SV2V_FLAGS  := $(INCLUDES_FLAGS) $(PACKAGE_SRC)

#H# all                 : Run linter, FPGA synthesis and simulation
all: lint rtl-synth rtl-sim fpga-test

#H# veritedium          : Run veritedium AUTO features
veritedium:
	@if [[ "$(DW_VERBOSE)" == "yes" ]]; then echo -e "$(_flag_)Running Veritedium Autocomplete..."; fi
	@$(foreach SRC,$(VERILOG_SRC),$(call veritedium-command,$(SRC)))
	@$(foreach SRC,$(SVERILOG_SRC),$(call veritedium-command,$(SRC)))
	@if [[ "$(DW_VERBOSE)" == "yes" ]]; then echo -e "$(_flag_)Deleting unnecessary backup files (*~ or *.bak)..."; fi
	@find ./* -name "*~" -delete
	@find ./* -name "*.bak" -delete
	@if [[ "$(DW_VERBOSE)" == "yes" ]]; then echo -e "$(_flag_)Finished!$(_reset_)"; fi

#H# lint                : Run the RTL code linter
lint: print-rtl-srcs
	@if [[ "$(TOP_MODULE)" == "" ]]; then\
		echo -e "$(_error_)[ERROR] No defined top module!$(_reset_)";\
		exit;\
	else\
		if [[ "$(DW_VERBOSE)" == "yes" ]]; then echo -e "$(_info_)\n[INFO] Linting using $(LINT) tool$(_reset_)"; fi;\
		for tmodule in $(TOP_MODULE); do\
			$(MAKE) lint-module TOP_MODULE=$${tmodule};\
		done;\
	fi

#H# lint-module         : Run pre-specified linter for <top module>, use 'make lint' instead
lint-module:
	@if [[ "$(DW_VERBOSE)" == "yes" ]]; then\
		echo -e "$(_flag_)\n [+] Top Module : [ $(TOP_MODULE) ]\n$(_reset_)";\
		echo "$(RTL_LINTER)";\
		echo -e "$(_flag_) cmd: $(LINT) $(LINT_FLAGS)\n$(_reset_)";\
	fi;\
	$(LINT) $(LINT_FLAGS);\

#H# rtl-synth           : Run RTL synthesis
ifeq ($(USE_SV2V),yes)
rtl-synth: sv2v-srcs
	$(MAKE) SV2V_RERUN=yes rtl-synth-run
rtl-synth-run:
else
rtl-synth:
endif
	@if [[ "$(DW_VERBOSE)" == "yes" ]]; then echo -e "$(_info_)\n[INFO] RTL Synthesis$(_reset_)"; fi;\
	if [[ "$(RTL_SYN_TOOLS)" == "" ]]; then\
		echo -e "$(_error_)[ERROR] No defined RTL synthesis tool! Define \"RTL_SYN_TOOLS\" environment variable or define it in the \"project.config\" file."$(_reset_);\
	else\
		stool_list=($(RTL_SYN_TOOLS));\
		for sidx in `seq 0 $$(($${#stool_list[@]}-1))`; do\
			stool=$${stool_list[$$sidx]};\
			if [[ "$(TOP_MODULE)" == "" ]]; then\
				echo -e "$(_error_)[ERROR] No defined top module!$(_reset_)";\
			else\
				if [[ "$(DW_VERBOSE)" == "yes" ]]; then echo -e "$(_info_)\n[INFO] Running $${stool} synthesis tool$(_reset_)"; fi;\
				tmodule_list=($(TOP_MODULE));\
				for tidx in `seq 0 $$(($${#tmodule_list[@]}-1))`; do\
					tmodule=$${tmodule_list[$$tidx]};\
					if [[ "$(DW_VERBOSE)" == "yes" ]]; then echo -e "$(_flag_)\n [*] Synthesis Top Module : $${tmodule}\n$(_reset_)"; fi;\
					$(MAKE) -C $(SYNTHESIS_ENV_DIR)/$${stool} rtl-synth\
						TOP_MODULE=$${tmodule}\
						SYN_BUILD_DIR="$(BUILD_DIR)/syn/$${stool}"\
						VERILOG_SRC="$(VERILOG_SRC) $(SVERILOG_SRC)"\
						VERILOG_HEADERS="$(VERILOG_HEADERS) $(SVERILOG_HEADERS)"\
						PACKAGE_SRC="$(PACKAGE_SRC)"\
						MEM_SRC="$(MEM_SRC)"\
						RTL_PATHS="$(RTL_PATHS)";\
				done;\
			fi;\
		done;\
	fi

#H# rtl-sim             : Run RTL simulation
rtl-sim:
	@if [[ "$(DW_VERBOSE)" == "yes" ]]; then echo -e "$(_info_)\n[INFO] RTL Simulation\n$(_reset_)"; fi;\
	if [[ "$(SIM_TOOL)" == "" ]]; then\
		echo -e "$(_error_)[ERROR] No defined RTL simulation tool! Define \"SIM_TOOL\" environment variable or define it in the \"project.config\" file.$(_reset_)";\
	else\
		stool_list=($(SIM_TOOL));\
		for sidx in `seq 0 $$(($${#stool_list[@]}-1))`; do\
			stool=$${stool_list[$$sidx]};\
			if [[ "$(SIM_MODULES)" == "" ]]; then\
				echo -e "$(_error_)[ERROR] No defined simulation top module!$(_reset_)";\
			else\
				if [[ "$(DW_VERBOSE)" == "yes" ]]; then echo -e "$(_info_)[INFO] Simulation with $${stool} tool\n$(_reset_)"; fi;\
				smodule_list=($(SIM_MODULES));\
				for sidx in `seq 0 $$(($${#smodule_list[@]}-1))`; do\
					smodule=$${smodule_list[$$sidx]};\
					if [[ "$(DW_VERBOSE)" == "yes" ]]; then echo -e "$(_flag_)\n [*] Simulating Top Module : $${smodule}\n$(_reset_)"; fi;\
					$(MAKE) -C $(SIMULATION_ENV_DIR)/$${stool} sim\
						SIM_TOP_MODULE=$${smodule}\
						SIM_TOOL=$${stool}\
						SIM_SOURCE_DIR="$(TB_SOURCE_DIR)"\
						SIM_BUILD_DIR="$(BUILD_DIR)/sim/$${stool}"\
						SIM_CREATE_VCD=$(SIM_CREATE_VCD)\
						SIM_OPEN_WAVE=$(SIM_OPEN_WAVE)\
						EXT_VERILOG_SRC="$(VERILOG_SRC)"\
						EXT_SVERILOG_SRC="$(SVERILOG_SRC)"\
						EXT_VERILOG_HEADERS="$(VERILOG_HEADERS)"\
						EXT_SVERILOG_HEADERS="$(SVERILOG_HEADERS)"\
						EXT_PACKAGE_SRC="$(PACKAGE_SRC)"\
						EXT_MEM_SRC="$(MEM_SRC)"\
						EXT_RTL_PATHS="$(RTL_PATHS)";\
				done;\
			fi;\
		done;\
	fi

#H# fpga-test           : Run the FPGA test
fpga-test:
	@if [[ "$(DW_VERBOSE)" == "yes" ]]; then echo -e "$(_flag_)\n[INFO] FPGA Test$(_reset_)"; fi;\
	if [[ "$(FPGA_TEST)" == "" ]]; then\
		echo -e "$(_error_)[ERROR] No defined FPGA test! Define it in the \"project.config\" file.$(_reset_)";\
	else\
		ftest_list=($(FPGA_TEST));\
		for fidx in `seq 0 $$(($${#ftest_list[@]}-1))`; do\
			ftest=$${ftest_list[$$fidx]};\
			$(MAKE) check-dir-env RTL_ENV_FEATURE=fpga RTL_ENV_SUBFEATURE=$${ftest};\
			fpga_target=$${ftest^^}_TARGET;\
			fpga_device=$${ftest^^}_DEVICE;\
			if [[ "$(DW_VERBOSE)" == "yes" ]]; then\
				echo -e "$(_flag_)\n [*] Running compilation flow - $${ftest^}";\
				echo -e "  |-> Target     : $${!fpga_target}";\
				echo -e "  |-> Device     : $${!fpga_device}";\
				echo -e "  |-> Top Module : $(FPGA_TOP_MODULE)\n$(_reset_)";\
			fi;\
			$(MAKE) -C $(FPGA_TEST_DIR)/$${ftest} $${ftest}-project\
				EXT_VERILOG_SRC="$(VERILOG_SRC) $(SVERILOG_SRC)"\
				EXT_VERILOG_HEADERS="$(VERILOG_HEADERS) $(SVERILOG_HEADERS)"\
				EXT_PACKAGE_SRC="$(PACKAGE_SRC)"\
				EXT_MEM_SRC="$(MEM_SRC)"\
				EXT_RTL_PATHS="$(RTL_PATHS)";\
		done;\
	fi

#H# fpga-rtl-sim        : Run FPGA Test RTL simulation
fpga-rtl-sim:
	@if [[ "$(DW_VERBOSE)" == "yes" ]]; then echo -e "$(_info_)\n[INFO] FPGA Test Simulation\n$(_reset_)"; fi;\
	if [[ "$(FPGA_SIM_TEST)" == "" ]]; then\
		echo -e "$(_error_)[ERROR] No defined FPGA test simulation target! Define it in the \"project.config\" file.$(_reset_)";\
	elif [[ "$(FPGA_SIM_TOOL)" == "" ]]; then\
		echo -e "$(_error_)[ERROR] No defined simulation tool for the FPGA test! Define it in the \"project.config\" file.$(_reset_)";\
	else\
		fsim_list=($(FPGA_SIM_TEST));\
		stool_list=($(FPGA_SIM_TOOL));\
		for fidx in `seq 0 $$(($${#fsim_list[@]}-1))`; do\
			fsim=$${fsim_list[$$fidx]};\
			$(MAKE) check-dir-env RTL_ENV_FEATURE=fpga RTL_ENV_SUBFEATURE=$${fsim};\
			fsim_modules=FPGA_SIM_MODULES_$${fsim^^};\
			for sidx in `seq 0 $$(($${#stool_list[@]}-1))`; do\
				stool=$${stool_list[$$sidx]};\
				$(MAKE) -C $(FPGA_TEST_DIR)/$${fsim} fpga-rtl-sim\
					FPGA_SIM_MODULES="$${!fsim_modules}"\
					SIM_TOOL="$${stool}"\
					SIM_CREATE_VCD=$(FPGA_SIM_CREATE_VCD)\
					SIM_OPEN_WAVE=$(FPGA_SIM_OPEN_WAVE)\
					EXT_VERILOG_SRC="$(VERILOG_SRC) $(SVERILOG_SRC)"\
					EXT_VERILOG_HEADERS="$(VERILOG_HEADERS) $(SVERILOG_HEADERS)"\
					EXT_PACKAGE_SRC="$(PACKAGE_SRC)"\
					EXT_MEM_SRC="$(MEM_SRC)"\
					EXT_RTL_PATHS="$(RTL_PATHS)";\
			done;\
		done;\
	fi

#H# fpga-flash          : Flash FPGA bitstream
fpga-flash:
	@if [[ "$(FPGA_TEST)" == "" ]]; then\
		echo -e "$(_error_)\n[ERROR] No defined FPGA test! Define it in the \"project.config\" file.$(_reset_)";\
	else\
		ftest_list=($(FPGA_TEST));\
		for fidx in `seq 0 $$(($${#ftest_list[@]}-1))`; do\
			ftest=$${ftest_list[$$fidx]};\
			$(MAKE) check-dir-env RTL_ENV_FEATURE=fpga RTL_ENV_SUBFEATURE=$${ftest};\
			fpga_target=$${ftest^^}_TARGET;\
			fpga_device=$${ftest^^}_DEVICE;\
			if [[ "$(DW_VERBOSE)" == "yes" ]]; then\
				echo -e "$(_flag_)\n [*] Running flash FPGA job - $${ftest^}";\
				echo -e "  |-> Target     : $${!fpga_target}";\
				echo -e "  |-> Device     : $${!fpga_device}";\
				echo -e "  |-> Top Module : $(FPGA_TOP_MODULE)\n$(_reset_)";\
			fi;\
			$(MAKE) -C $(FPGA_TEST_DIR)/$${ftest} $${ftest}-flash-fpga\
				EXT_VERILOG_SRC="$(VERILOG_SRC) $(SVERILOG_SRC)"\
				EXT_VERILOG_HEADERS="$(VERILOG_HEADERS) $(SVERILOG_HEADERS)"\
				EXT_PACKAGE_SRC="$(PACKAGE_SRC)"\
				EXT_MEM_SRC="$(MEM_SRC)"\
				EXT_RTL_PATHS="$(RTL_PATHS)";\
		done;\
	fi

#H# lint-fpga           : Run the verilator linter for the RTL code used in the FPGA test
lint-fpga-test:
	@if [[ "$(FPGA_TEST)" == "" ]]; then\
		echo -e "$(_error_)[ERROR] No defined FPGA test! Define it in the \"project.config\" file.$(_reset_)";\
	else\
		ftest_list=($(FPGA_TEST));\
		for fidx in `seq 0 $$(($${#ftest_list[@]}-1))`; do\
			ftest=$${ftest_list[$$fidx]};\
			$(MAKE) check-dir-env RTL_ENV_FEATURE=fpga RTL_ENV_SUBFEATURE=$${ftest};\
			if [[ "$(DW_VERBOSE)" == "yes" ]]; then\
				echo -e "$(_flag_)\n [*] Running linter for $${ftest^} FPGA test";\
				echo -e "  |-> Top Module : $(FPGA_TOP_MODULE)\n$(_reset_)";\
			fi;\
			$(MAKE) -C $(FPGA_TEST_DIR)/$${ftest} lint\
				EXT_VERILOG_SRC="$(VERILOG_SRC) $(SVERILOG_SRC)"\
				EXT_VERILOG_HEADERS="$(VERILOG_HEADERS) $(SVERILOG_HEADERS)"\
				EXT_PACKAGE_SRC="$(PACKAGE_SRC)"\
				EXT_MEM_SRC="$(MEM_SRC)"\
				EXT_RTL_PATHS="$(RTL_PATHS)";\
		done;\
	fi

#H# clean               : Clean the build directory
clean: del-bak
	rm -rf ./build/*
	rm -rf ./spyglass_output/*
	rm -rf .duckwizard/simulation/questasim/transcript
	rm -rf .duckwizard/simulation/questasim/vsim.wlf

#H# clean-all           : Clean all the build directories
clean-all: clean
	rm -rf ./build
	rm -rf ./spyglass_output
	@syn_tool_list=($(SUPPORTED_SYNTHESIS));\
	for sidx in `seq 0 $$(($${#syn_tool_list[@]}-1))`; do\
		stool=$${syn_tool_list[$$sidx]};\
		if [ -d $(SYNTHESIS_ENV_DIR)/$${stool} ]; then $(MAKE) -C $(SYNTHESIS_ENV_DIR)/$${stool} clean; fi;\
	done
	@sim_tool_list=($(SUPPORTED_SIMULATION));\
	for sidx in `seq 0 $$(($${#sim_tool_list[@]}-1))`; do\
		stool=$${sim_tool_list[$$sidx]};\
		if [ -d $(SIMULATION_ENV_DIR)/$${stool} ]; then $(MAKE) -C $(SIMULATION_ENV_DIR)/$${stool} clean; fi;\
	done
	@fpga_test_list=($(SUPPORTED_FPGA_TEST));\
	for fidx in `seq 0 $$(($${#fpga_test_list[@]}-1))`; do\
		ftest=$${fpga_test_list[$$fidx]};\
		if [ -d $(FPGA_TEST_DIR)/$${ftest} ]; then $(MAKE) -C $(FPGA_TEST_DIR)/$${ftest} clean; fi;\
		if [ -d $(FPGA_TEST_DIR)/$${ftest}/simulation ]; then $(MAKE) -C $(FPGA_TEST_DIR)/$${ftest}/simulation clean; fi;\
	done

#H# env-dirs            : Create features environment directories (synthesis, fpga-test, simulation, etc.)
env-dirs:
	@if [[ "$(FPGA_TEST)" != "" ]]; then\
		for ftest in $(FPGA_TEST); do\
			$(MAKE) check-dir-env RTL_ENV_FEATURE=fpga RTL_ENV_SUBFEATURE=$${ftest};\
		done;\
	fi

#H# sv2v-srcs           : Convert RTL sources from SystemVerilog to Verilog (using sv2v tool)
sv2v-srcs: $(SVERILOG_SRC)
	@rm -rvf .sv2v/*
	@mkdir -p $(SV2V_RTL_DIR)
	@for src in $^; do $(MAKE) sv2v-convert SV2V_SOURCE=$${src}; done

#H# sv2v-convert        : Convert SystemVerilog module to Verilog
sv2v-convert: check-sv2v
	sv2v --write=$(SV2V_DEST) $(SV2V_FLAGS) $(SV2V_SOURCE)

#H# init-repo           : Initialize repository (submodules)
init-repo:
	@git submodule update --init --recursive

#H# filelist            : Create filelist.f
filelist: $(RTL_SRC)
	$(call print-filelist,$(DW_FILELIST),$(TOP_DIR))
	@echo -e "\n\u2714 [OK] Written into $(DW_FILELIST)"

#H# rm-git-db           : Remove GIT databases (.git and .gitmodules)
rm-git-db: init-repo
	$(eval remote-url=$(shell git config --get remote.origin.url))
	@if [[ "$(remote-url)" == "$(REMOTE-URL-SSH)" ]] || [[ "$(remote-url)" == "$(REMOTE-URL-HTTPS)" ]] ; then\
		find ./* -name ".git";\
		find ./* -name ".gitmodules";\
	else\
	  echo -e "$(_error_)\n [ERROR] You are trying to delete your own project GIT database!\n$(_flag_)  >>> $(remote-url)$(_reset_)";\
	fi
#		rm -rf .git .gitmodules;\

#H# update-files        : Update files from template to the project structure
update-files:
	git clone $(REMOTE-URL-HTTPS) .dw-temp-update && \
	cd .dw-temp-update && \
	git submodule update --init --recursive && \
	.duckwizard/scripts/copy_files .duckwizard/scripts/duckWizard.list $(TOP_DIR) && \
	.duckwizard/scripts/restore_config $(CONFIG_FILE) project.config && \
	cd .. && rm -rf .dw-temp-update

#H# upgrade-env         : Upgrade the duckWizard environment (replaces "make update-files")
upgrade-env:
	@echo -e "$(_info_)[INFO] Upgrading duckWizard environment$(_reset_)"
	@if [ ! -d duckwizard ]; then \
		echo -e "$(_info_)[INFO] Cloning the duckWizard repository$(_reset_)"; \
		git clone https://github.com/m4j0rt0m/duckwizard.git duckwizard; \
		echo "NEW_DUCKWIZARD=1" > .duckwizard_created.tmp; \
	else \
		echo -e "$(_info_)[INFO] Updating the duckWizard repository$(_reset_)"; \
		cd duckwizard && git pull; \
	fi
	@echo -e "$(_info_)[INFO] Creating patch for .duckwizard$(_reset_)"
	@diff -urN .duckwizard duckwizard/.duckwizard > duckwizard_patch.diff || true
	@echo -e "$(_info_)[INFO] Applying patch to update .duckwizard$(_reset_)"
	@patch -p1 < duckwizard_patch.diff || true
	@rm duckwizard_patch.diff
	@echo -e "$(_info_)[INFO] Backing up the current project.config$(_reset_)"
	@if [ -f project.config ]; then \
		cp project.config project.config.bak; \
		echo -e "$(_info_)[INFO] Performing three-way merge of project.config$(_reset_)"; \
		diff3 -m project.config $(CONFIG_ORIG_FILE) duckwizard/project.config > merged_project.config || true; \
		if grep -q '<<<<<<<' merged_project.config; then \
			echo -e "$(_info_)[INFO] Merge conflicts detected in project.config. Please manually resolve them in project.config.conflicted.$(_reset_)"; \
			mv merged_project.config project.config.conflicted; \
		else \
			mv merged_project.config project.config; \
			echo -e "$(_info_)[INFO] Merge complete. Updated project.config has been saved.$(_reset_)"; \
			rm project.config.bak; \
		fi; \
	else \
		echo -e "$(_info_)[INFO] No project.config found. Copying the new one from duckWizard.$(_reset_)"; \
		cp duckwizard/project.config .; \
	fi
	@if [ -f .duckwizard_created.tmp ]; then \
		echo -e "$(_info_)[INFO] Removing temporary duckWizard repository$(_reset_)"; \
		rm -rf duckwizard; \
		rm .duckwizard_created.tmp; \
	fi
	@echo -e "$(_info_)[INFO] Ensuring all required directories are present$(_reset_)"
	@mkdir -p src/rtl src/include src/mem src/package
	@mkdir -p tb/rtl tb/include tb/mem tb/package tb/scripts tb/cxx
	@echo -e "$(_info_)[INFO] duckWizard environment upgrade complete!$(_reset_)"

#H# init-env            : Initialize the duckWizard environment
init-env:
	@echo -e "$(_info_)[INFO] Initializing the environment$(_reset_)"
	@mkdir -p src/rtl src/include src/mem src/package
	@mkdir -p tb/rtl tb/include tb/mem tb/package tb/scripts tb/cxx
	@echo -e "$(_info_)[INFO] Directories created:$(_reset_)"
	@echo -e "  - src/rtl     (Used for Verilog/SystemVerilog source files: .v, .sv)"
	@echo -e "  - src/include (Used for header files: .h, .v, .vh, .sv, .svh)"
	@echo -e "  - src/mem     (Used for memory initialization files: .bin, .hex)"
	@echo -e "  - src/package (Used for SystemVerilog packages: .sv)"
	@echo -e "  - tb/rtl      (Used for testbench Verilog/SystemVerilog source files: .v, .sv)"
	@echo -e "  - tb/include  (Used for testbench headers: .h, .v, .vh, .sv, .svh)"
	@echo -e "  - tb/mem      (Used for testbench memory initialization files: .bin, .hex)"
	@echo -e "  - tb/package  (Used for testbench packages: .sv)"
	@echo -e "  - tb/scripts  (Used for testbench scripts)"
	@echo -e "  - tb/cxx      (Used for C++ files in testbenches)"
	@FOUND=0; \
	if [ ! -d ./.duckwizard ]; then \
		cp -r ./duckwizard/.duckwizard ./.duckwizard; \
		echo -e "$(_info_)[INFO] .duckwizard directory copied to the current directory$(_reset_)"; \
	else \
		echo -e "$(_info_)[INFO] .duckwizard directory already exists, skipping copy$(_reset_)"; \
		FOUND=1; \
	fi; \
	if [ ! -f ./project.config ]; then \
		cp ./duckwizard/project.config ./project.config; \
		echo -e "$(_info_)[INFO] project.config file copied$(_reset_)"; \
	else \
		echo -e "$(_info_)[INFO] project.config already exists, skipping copy$(_reset_)"; \
		FOUND=1; \
	fi; \
	if [ ! -f ./Makefile ]; then \
		cp ./duckwizard/Makefile ./Makefile; \
		echo -e "$(_info_)[INFO] No Makefile found, copying default Makefile from duckwizard$(_reset_)"; \
	else \
		echo -e "$(_info_)[INFO] A Makefile already exists. Please ensure the following line is added to your Makefile to include the duckwizard Makefile:$(_reset_)"; \
		echo -e "  include .duckwizard/Makefile"; \
	fi; \
	if [ $${FOUND} -eq 1 ]; then \
		read -p "Do you want to upgrade the environment (y/n)? " ans && [ $${ans:-n} = y ] && \
		make upgrade-env || echo -e "$(_info_)[INFO] Skipping environment upgrade$(_reset_)"; \
	fi; \
	echo -e "$(_info_)[INFO] Environment initialization complete$(_reset_)"

#H# check-duckwizard    : A friendly check to see if duckWizard is included
check-duckwizard:
	@echo "Hello, world! from duckWizard"

#H# help                : Display help
help: $(DUCKWIZARD_DIR)/Makefile $(SCRIPTS_DIR)/misc.mk
	@echo -e "\n[Help!...(8)]\n"
	@echo -e "Commands:"
	@sed -n 's/^#H#//p' $^
	@echo ""
	@$(MAKE) help-vars

#H# help-vars           : Display environment variables
help-vars: $(SCRIPTS_DIR)/config.mk
	@echo -e "Variables:"
	@sed -n 's/^#V#//p' $^
	@echo ""

#H# help-all            : Display complete rules help
help-all: help
	@syn_tool_list=($(SUPPORTED_SYNTHESIS));\
	for sidx in `seq 0 $$(($${#syn_tool_list[@]}-1))`; do\
		stool=$${syn_tool_list[$$sidx]};\
		if [ -d $(SYNTHESIS_ENV_DIR)/$${stool} ]; then $(MAKE) -C $(SYNTHESIS_ENV_DIR)/$${stool} help; fi;\
	done
	@sim_tool_list=($(SUPPORTED_SIMULATION));\
	for sidx in `seq 0 $$(($${#sim_tool_list[@]}-1))`; do\
		stool=$${sim_tool_list[$$sidx]};\
		if [ -d $(SIMULATION_ENV_DIR)/$${stool} ]; then $(MAKE) -C $(SIMULATION_ENV_DIR)/$${stool} help; fi;\
	done
	@fpga_test_list=($(SUPPORTED_FPGA_TEST));\
	for fidx in `seq 0 $$(($${#fpga_test_list[@]}-1))`; do\
		ftest=$${fpga_test_list[$$fidx]};\
		if [ -d $(FPGA_TEST_DIR)/$${ftest} ]; then $(MAKE) -C $(FPGA_TEST_DIR)/$${ftest} help; fi;\
	done

.PHONY: all lint lint-module rtl-synth rtl-sim fpga-test fpga-flash print-rtl-srcs print-config filelist env-dirs check-config veritedium clean clean-all del-bak help help-all check-duckwizard init-env upgrade-env

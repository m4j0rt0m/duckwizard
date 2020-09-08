###################################################################
# Project:                                                        #
# Description:      RTL Development Main Makefile                 #
#                                                                 #
# Template written by Abraham J. Ruiz R.                          #
#   https://github.com/m4j0rt0m/rtl-develop-template              #
###################################################################

MKFILE_PATH             = $(abspath $(firstword $(MAKEFILE_LIST)))
TOP_DIR                 = $(shell dirname $(MKFILE_PATH))

### directories ###
SOURCE_DIR              = $(TOP_DIR)/src
SYNTHESIS_DIR           = $(TOP_DIR)/synthesis
SIMULATION_DIR          = $(TOP_DIR)/simulation
FPGA_TEST_DIR           = $(TOP_DIR)/fpga
SCRIPTS_DIR             = $(TOP_DIR)/scripts

### sources directories ###
RTL_DIRS                = $(wildcard $(shell find $(SOURCE_DIR) -type d \( -iname rtl \)))
INCLUDE_DIRS            = $(wildcard $(shell find $(SOURCE_DIR) -type d \( -iname include \)))
PACKAGE_DIRS            = $(wildcard $(shell find $(SOURCE_DIR) -type d \( -iname package \)))
MEM_DIRS                = $(wildcard $(shell find $(SOURCE_DIR) -type d \( -iname mem \)))
RTL_PATHS               = $(RTL_DIRS) $(INCLUDE_DIRS) $(PACKAGE_DIRS) $(MEM_DIRS)

### sources wildcards ###
VERILOG_SRC             = $(wildcard $(shell find $(RTL_DIRS) -type f \( -iname \*.v -o -iname \*.sv -o -iname \*.vhdl \)))
VERILOG_HEADERS         = $(wildcard $(shell find $(INCLUDE_DIRS) -type f \( -iname \*.h -o -iname \*.vh -o -iname \*.svh -o -iname \*.sv -o -iname \*.v \)))
PACKAGE_SRC             = $(wildcard $(shell find $(PACKAGE_DIRS) -type f \( -iname \*.sv \)))
MEM_SRC                 = $(wildcard $(shell find $(MEM_DIRS) -type f \( -iname \*.bin -o -iname \*.hex \)))

### makefile includes ###
include $(SCRIPTS_DIR)/config.mk
include $(SCRIPTS_DIR)/misc.mk
include $(SCRIPTS_DIR)/funct.mk

### include flags ###
INCLUDES_FLAGS        = $(addprefix -I, $(INCLUDE_DIRS))

### linter flags ###
LINT                  = verilator
LINT_SV_FLAGS         = +1800-2017ext+sv -sv
LINT_W_FLAGS          = -Wall -Wno-IMPORTSTAR -Wno-fatal
LINT_FLAGS            = --lint-only $(LINT_SV_FLAGS) $(LINT_W_FLAGS) --quiet-exit --error-limit 200 $(PACKAGE_SRC) $(INCLUDES_FLAGS)

#H# all                 : Run linter, FPGA synthesis and simulation
all: veritedium lint rtl-synth rtl-sim fpga-test

#H# veritedium          : Run veritedium AUTO features
veritedium:
	$(foreach SRC,$(VERILOG_SRC),$(call veritedium-command,$(SRC)))

#H# lint                : Run the verilator linter for the RTL code
lint: print-rtl-srcs
	@if [[ "$(TOP_MODULE)" == "" ]]; then\
		echo -e "$(_error_)[ERROR] No defined top module!$(_reset_)";\
	else\
		echo -e "$(_info_)\n[INFO] Linting using $(LINT) tool$(_reset_)";\
		for tmodule in $(TOP_MODULE);\
		do\
			echo -e "$(_flag_)\n [+] Top Module : [ $${tmodule} ]\n$(_reset_)";\
			$(LINT) $(LINT_FLAGS) $(VERILOG_SRC) --top-module $${tmodule};\
		done;\
	fi

#H# rtl-synth           : Run RTL synthesis
rtl-synth:
	@echo -e "$(_info_)\n[INFO] RTL Synthesis$(_reset_)";\
	if [[ "$(RTL_SYN_TOOLS)" == "" ]]; then\
		echo -e "$(_error_)[ERROR] No defined RTL synthesis tool! Define \"RTL_SYN_TOOLS\" environment variable or define it in the \"project.config\" file."$(_reset_);\
	else\
		echo -e "$(_segment_)\n [+] RTL Synthesis Tools:";\
		for stool in $(RTL_SYN_TOOLS);\
		do\
			echo "  |-> $${stool}";\
		done;\
		echo -e "$(_reset_)";\
		for stool in $(RTL_SYN_TOOLS);\
		do\
			if [[ "$(TOP_MODULE)" == "" ]]; then\
				echo -e "$(_error_)[ERROR] No defined top module!$(_reset_)";\
			else\
				echo -e "$(_info_)\n[INFO] Running $${stool} synthesis tool$(_reset_)";\
				for tmodule in $(TOP_MODULE);\
				do\
					echo -e "$(_flag_)\n [*] Synthesis Top Module : $${tmodule}\n$(_reset_)";\
					$(MAKE) -C $(SYNTHESIS_DIR)/$${stool} rtl-synth\
						TOP_MODULE=$${tmodule}\
					  VERILOG_SRC="$(VERILOG_SRC)"\
					  VERILOG_HEADERS="$(VERILOG_HEADERS)"\
					  PACKAGE_SRC="$(PACKAGE_SRC)"\
					  MEM_SRC="$(MEM_SRC)"\
					  RTL_PATHS="$(RTL_PATHS)";\
			  done;\
		  fi;\
		done;\
	fi

#H# rtl-sim             : Run RTL simulation
rtl-sim:
	@echo -e "$(_info_)\n[INFO] RTL Simulation\n$(_reset_)";\
	if [[ "$(SIM_TOOL)" == "" ]]; then\
		echo -e "$(_error_)[ERROR] No defined RTL simulation tool! Define \"SIM_TOOL\" environment variable or define it in the \"project.config\" file.$(_reset_)";\
	else\
		for stool in $(SIM_TOOL);\
		do\
			if [[ "$(SIM_MODULES)" == "" ]]; then\
				echo -e "$(_error_)[ERROR] No defined simulation top module!$(_reset_)";\
			else\
				echo -e "$(_info_)[INFO] Simulation with $${stool} tool\n$(_reset_)";\
				for smodule in $(SIM_MODULES);\
				do\
					echo -e "$(_flag_)\n [*] Simulating Top Module : $${smodule}\n$(_reset_)";\
					$(MAKE) -C $(SIMULATION_DIR) sim\
						SIM_TOP_MODULE=$${smodule}\
						SIM_TOOL=$${stool}\
						SIM_CREATE_VCD=$(SIM_CREATE_VCD)\
						SIM_OPEN_WAVE=$(SIM_OPEN_WAVE)\
						EXT_VERILOG_SRC="$(VERILOG_SRC)"\
						EXT_VERILOG_HEADERS="$(VERILOG_HEADERS)"\
						EXT_PACKAGE_SRC="$(PACKAGE_SRC)"\
						EXT_MEM_SRC="$(MEM_SRC)"\
						EXT_INCLUDE_DIRS="$(INCLUDE_DIRS)"\
						EXT_RTL_PATHS="$(RTL_PATHS)";\
				done;\
			fi;\
		done;\
	fi

#H# fpga-test           : Run the FPGA test
fpga-test:
	@echo -e "$(_flag_)\n[INFO] FPGA Test$(_reset_)";\
	if [[ "$(FPGA_SYNTH_ALTERA)" != "yes" ]] && [[ "$(FPGA_SYNTH_LATTICE)" != "yes" ]]; then\
		echo -e "$(_error_)[ERROR] No defined FPGA test! Define it in the \"project.config\" file.$(_reset_)";\
	else\
		if [[ "$(FPGA_SYNTH_ALTERA)" == "yes" ]]; then\
			echo -e "$(_flag_)\n [*] Running compilation flow for Altera FPGA";\
			echo "  |-> Target     : $(ALTERA_TARGET)";\
			echo "  |-> Device     : $(ALTERA_DEVICE)";\
			echo -e "  |-> Top Module : $(FPGA_TOP_MODULE)\n$(_reset_)";\
			$(MAKE) -C $(FPGA_TEST_DIR)/altera altera-project\
			  EXT_VERILOG_SRC="$(VERILOG_SRC)"\
			  EXT_VERILOG_HEADERS="$(VERILOG_HEADERS)"\
			  EXT_PACKAGE_SRC="$(PACKAGE_SRC)"\
			  EXT_MEM_SRC="$(MEM_SRC)"\
			  EXT_INCLUDE_DIRS="$(INCLUDE_DIRS)"\
			  EXT_RTL_PATHS="$(RTL_PATHS)";\
		fi;\
		if [[ "$(FPGA_SYNTH_LATTICE)" == "yes" ]]; then\
			echo -e "$(_flag_)\n [*] Running compilation flow for Lattice FPGA";\
			echo "  |-> Target     : $(LATTICE_TARGET)";\
			echo "  |-> Device     : $(LATTICE_DEVICE)";\
			echo -e "  |-> Top Module : $(FPGA_TOP_MODULE)\n$(_reset_)";\
			$(MAKE) -C $(FPGA_TEST_DIR)/lattice lattice-project\
			  EXT_VERILOG_SRC="$(VERILOG_SRC)"\
			  EXT_VERILOG_HEADERS="$(VERILOG_HEADERS)"\
			  EXT_PACKAGE_SRC="$(PACKAGE_SRC)"\
			  EXT_MEM_SRC="$(MEM_SRC)"\
			  EXT_INCLUDE_DIRS="$(INCLUDE_DIRS)"\
			  EXT_RTL_PATHS="$(RTL_PATHS)";\
		fi;\
	fi

#H# fpga-flash          : Flash FPGA bitstream
fpga-flash:
	@if [[ "$(FPGA_SYNTH_ALTERA)" != "yes" ]] && [[ "$(FPGA_SYNTH_LATTICE)" != "yes" ]]; then\
		echo -e "$(_error_)\n[ERROR] No defined FPGA test! Define it in the \"project.config\" file.$(_reset_)";\
	else\
		if [[ "$(FPGA_SYNTH_ALTERA)" == "yes" ]]; then\
			$(MAKE) -C $(FPGA_TEST_DIR)/altera altera-flash-fpga\
				EXT_VERILOG_SRC="$(VERILOG_SRC)"\
				EXT_VERILOG_HEADERS="$(VERILOG_HEADERS)"\
				EXT_PACKAGE_SRC="$(PACKAGE_SRC)"\
				EXT_MEM_SRC="$(MEM_SRC)"\
				EXT_INCLUDE_DIRS="$(INCLUDE_DIRS)"\
				EXT_RTL_PATHS="$(RTL_PATHS)";\
		fi;\
		if [[ "$(FPGA_SYNTH_LATTICE)" == "yes" ]]; then\
			$(MAKE) -C $(FPGA_TEST_DIR)/lattice lattice-flash-fpga\
				EXT_VERILOG_SRC="$(VERILOG_SRC)"\
				EXT_VERILOG_HEADERS="$(VERILOG_HEADERS)"\
				EXT_PACKAGE_SRC="$(PACKAGE_SRC)"\
				EXT_MEM_SRC="$(MEM_SRC)"\
				EXT_INCLUDE_DIRS="$(INCLUDE_DIRS)"\
				EXT_RTL_PATHS="$(RTL_PATHS)";\
		fi;\
	fi

#H# lint-fpga           : Run the verilator linter for the RTL code used in the FPGA test
lint-fpga-test:
	@if [[ "$(FPGA_SYNTH_ALTERA)" != "yes" ]] && [[ "$(FPGA_SYNTH_LATTICE)" != "yes" ]]; then\
		echo -e "$(_error_)[ERROR] No defined FPGA test! Define it in the \"project.config\" file.$(_reset_)";\
	else\
		if [[ "$(FPGA_SYNTH_ALTERA)" == "yes" ]]; then\
			echo -e "$(_flag_)\n [*] Running linter for Altera FPGA test";\
			echo -e "  |-> Top Module : $(FPGA_TOP_MODULE)\n$(_reset_)";\
			$(MAKE) -C $(FPGA_TEST_DIR)/altera lint\
			  EXT_VERILOG_SRC="$(VERILOG_SRC)"\
			  EXT_VERILOG_HEADERS="$(VERILOG_HEADERS)"\
			  EXT_PACKAGE_SRC="$(PACKAGE_SRC)"\
			  EXT_MEM_SRC="$(MEM_SRC)"\
			  EXT_INCLUDE_DIRS="$(INCLUDE_DIRS)"\
			  EXT_RTL_PATHS="$(RTL_PATHS)";\
		fi;\
		if [[ "$(FPGA_SYNTH_LATTICE)" == "yes" ]]; then\
			echo -e "$(_flag_)\n [*] Running linter for Lattice FPGA test";\
			echo -e "  |-> Top Module : $(FPGA_TOP_MODULE)\n$(_reset_)";\
			$(MAKE) -C $(FPGA_TEST_DIR)/lattice lint\
			  EXT_VERILOG_SRC="$(VERILOG_SRC)"\
			  EXT_VERILOG_HEADERS="$(VERILOG_HEADERS)"\
			  EXT_PACKAGE_SRC="$(PACKAGE_SRC)"\
			  EXT_MEM_SRC="$(MEM_SRC)"\
			  EXT_INCLUDE_DIRS="$(INCLUDE_DIRS)"\
			  EXT_RTL_PATHS="$(RTL_PATHS)";\
		fi;\
	fi

#H# clean               : Clean the build directory
clean: del-bak
	rm -rf build/*

#H# clean-all           : Clean all the build directories
clean-all: clean
	$(MAKE) -C $(SYNTHESIS_DIR)/quartus clean
	$(MAKE) -C $(SYNTHESIS_DIR)/yosys clean
	$(MAKE) -C $(FPGA_TEST_DIR)/altera clean
	$(MAKE) -C $(FPGA_TEST_DIR)/lattice clean
	$(MAKE) -C $(SIMULATION_DIR) clean

#H# help                : Display help
help: Makefile
	@echo -e "\nHelp!...(8)\n"
	@sed -n 's/^#H#//p' $<
	@echo ""

#H# help-all            : Display complete rules help
help-all: help
	@$(MAKE) -C $(SYNTHESIS_DIR)/quartus help
	@$(MAKE) -C $(SYNTHESIS_DIR)/yosys help
	@$(MAKE) -C $(FPGA_TEST_DIR)/altera help
	@$(MAKE) -C $(FPGA_TEST_DIR)/lattice help
	@$(MAKE) -C $(SIMULATION_DIR) help

.PHONY: all lint rtl-synth rtl-sim fpga-test print-rtl-srcs print-config check-config clean clean-all del-bak help help-all

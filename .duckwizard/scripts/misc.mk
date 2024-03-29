### display colours ###
_CBLUE=\033[0;34m
_CRED=\033[0;31m
_CWHITE=\033[0;37m
_COCHRE=\033[38;5;95m
_CYELLOW=\033[0;33m
_CBOLD=\033[1m
_reset_=\033[0m
_info_=$(_CBLUE)$(_CBOLD)
_flag_=$(_CYELLOW)
_error_=$(_CRED)
_segment_=$(_COCHRE)

### export variables ###
export _reset_
export _info_
export _flag_
export _error_
export _segment_

### environment directory ###
RTL_ENV_FEATURE_GIT:=$(subst .git,$(if $(RTL_ENV_SUBFEATURE),-$(RTL_ENV_FEATURE)-$(RTL_ENV_SUBFEATURE).git,-$(RTL_ENV_FEATURE).git),$(REMOTE-URL-HTTPS))
RTL_ENV_FEATURE_DIR:=$(if $(RTL_ENV_SUBFEATURE),$(RTL_ENV_FEATURE)/$(RTL_ENV_SUBFEATURE),$(RTL_ENV_FEATURE))

### filelist dir levels from root dir
FILELIST_BASE:=$(shell $(SCRIPTS_DIR)/filelist_base $(DW_FILELIST) $(TOP_DIR))

### check sv2v
ifeq (, $(shell which sv2v))
SV2V_IN_PATH:=false
else
SV2V_IN_PATH:=true
endif

filelist-test-info:
	@echo "filelist_base: '${FILELIST_BASE}'"

#H# print-config        : Display project configuration
print-config: check-config
	@echo -e "$(_info_)\n[INFO] Project Configuration File$(_reset_)";\
	echo -e "$(_segment_)";\
	echo -e " [+] Project";\
	echo -e "  |-> Project                    : $(PROJECT)";\
	echo -e "  |-> RTL Top                    : $(TOP_MODULE)";\
	echo -e " [+] RTL Synthesis";\
	echo -e "  |-> RTL Synthesis Tools        : $(RTL_SYN_TOOLS)";\
	echo -e "  |-> RTL Synthesis Clock        : $(RTL_SYN_CLK_SRC)";\
	for stool in $(RTL_SYN_TOOLS);\
	do\
		if [[ "$${stool}" == "quartus" ]]; then\
			echo -e "  |-> [+] Quartus Synthesis";\
			echo -e "  |    |-> Target                : $(RTL_SYN_Q_TARGET)";\
			echo -e "  |    |-> Device                : $(RTL_SYN_Q_DEVICE)";\
			echo -e "  |    |-> Clock Period (ns)     : $(RTL_SYN_Q_CLK_PERIOD)";\
		elif [[ "$${stool}" == "yosys" ]]; then\
			echo -e "  |-> [+] Yosys Synthesis";\
			echo -e "  |    |-> Target                : $(RTL_SYN_Y_TARGET)";\
			echo -e "  |    |-> Device                : $(RTL_SYN_Y_DEVICE)";\
			echo -e "  |    |-> Clock (MHz)           : $(RTL_SYN_Y_CLK_MHZ)";\
		fi;\
	done;\
	echo " [+] Simulation";\
	echo "  |-> Sim Top(s)                 : $(SIM_MODULES)";\
	echo "  |-> Sim Tool                   : $(SIM_TOOL)";\
	echo " [+] FPGA Test";\
	echo "  |-> FPGA Top                   : $(FPGA_TOP_MODULE)";\
	echo "  |-> FPGA Use Virtual Pins      : $(FPGA_VIRTUAL_PINS)";\
	echo "  |-> FPGA Board Test            : $(FPGA_BOARD_TEST)";\
	echo "  |-> FPGA Clock Source          : $(FPGA_CLOCK_SRC)";\
	echo "  |-> [+] Test with Altera FPGA  : $(FPGA_SYNTH_ALTERA)";\
	if [[ "$(FPGA_SYNTH_ALTERA)" == "yes" ]]; then\
		echo "  |    |-> Target                : $(ALTERA_TARGET)";\
		echo "  |    |-> Device                : $(ALTERA_DEVICE)";\
		echo "  |    |-> Package               : $(ALTERA_PACKAGE)";\
		echo "  |    |-> Min Temp              : $(ALTERA_MIN_TEMP)";\
		echo "  |    |-> Max Temp              : $(ALTERA_MAX_TEMP)";\
		if [[ "$(FPGA_CLOCK_SRC)" != "" ]]; then\
			echo "  |    |-> Clock Period          : $(ALTERA_CLOCK_PERIOD)";\
		fi;\
		if [[ "$(FPGA_VIRTUAL_PINS)" != "yes" ]]; then\
			echo "  |    |-> Pinout TCL            : $(FPGA_TEST_DIR)/altera/script/$(FPGA_TOP_MODULE)_set_pinout.tcl";\
		fi;\
	fi;\
	echo "  |-> [+] Test with Lattice FPGA : $(FPGA_SYNTH_LATTICE)";\
	if [[ "$(FPGA_SYNTH_LATTICE)" == "yes" ]]; then\
		echo "  |    |-> Device                : $(LATTICE_DEVICE)";\
		echo "  |    |-> Package               : $(LATTICE_PACKAGE)";\
		if [[ "$(FPGA_CLOCK_SRC)" != "" ]]; then\
			echo "  |    |-> Clock Frequency       : $(LATTICE_CLOCK_MHZ)";\
		fi;\
		if [[ $(FPGA_VIRTUAL_PINS) != "yes" ]]; then\
			echo "  |    |-> Pinout PCF            : $(FPGA_TEST_DIR)/lattice/script/$(FPGA_TOP_MODULE)_set_pinout.pcf";\
		fi;\
	fi;\
	echo -e "$(_reset_)"

#H# print-rtl-srcs      : Print RTL sources
print-rtl-srcs:
	$(call print-srcs-command)

#H# print-pkgs          : Print SV Packages source list (hierarchically ordered)
print-pkgs:
	@list_pkg=($(PACKAGE_SRC));\
	for idx in `seq 0 $$(($${#list_pkg[@]}-1))`; do\
		pkg_src=$${list_pkg[$$idx]};\
		echo "$${pkg_src}";\
	done

#H# print-pkgs-line     : Print SV Packages source in a single line (hierarchically ordered)
print-pkgs-line:
	@echo $(PACKAGE_SRC)

#H# check-dir-env       : Check if exists, if not, create the RTL env directory <RTL_ENV_FEATURE> <RTL_ENV_SUBFEATURE>
check-dir-env:
	@if [ ! -d $(RTL_ENV_FEATURE_DIR) ]; then\
		$(SCRIPTS_DIR)/pull-feature-repo-files $(RTL_ENV_FEATURE_GIT) $(RTL_ENV_FEATURE_DIR);\
	fi

#H# check-sv2v          : Check if sv2v tool is installed
check-sv2v:
	@if [[ "$(SV2V_IN_PATH)" != true ]]; then\
		echo " [!] sv2v is not installed nor in PATH, running install-helper...";\
		$(MAKE) install-sv2v;\
	fi

#H# install-sv2v        : Install sv2v tool (SystemVerilog to Verilog code conversion tool)
install-sv2v:
	@$(SCRIPTS_DIR)/install-sv2v

#H# show-dirs           : Show automatically recognized rtl directories
show-dirs:
	@rtl_dirs_list=($(RTL_DIRS));\
	inc_dirs_list=($(INCLUDE_DIRS));\
	pkg_dirs_list=($(PACKAGE_DIRS));\
	mem_dirs_list=($(MEM_DIRS));\
	rtl_paths_list=($(RTL_PATHS));\
	echo -e "RTL DIRS:";\
	for idx in `seq 0 $$(($${#rtl_dirs_list[@]}-1))`; do\
			rtl_dir=$${rtl_dirs_list[$$idx]};\
			echo -e "[$$idx] $${rtl_dir}";\
	done;\
	echo -e "INCLUDE DIRS:";\
	for idx in `seq 0 $$(($${#inc_dirs_list[@]}-1))`; do\
			inc_dir=$${inc_dirs_list[$$idx]};\
			echo -e "[$$idx] $${inc_dir}";\
	done;\
	echo -e "PACKAGE DIRS:";\
	for idx in `seq 0 $$(($${#pkg_dirs_list[@]}-1))`; do\
			pkg_dir=$${pkg_dirs_list[$$idx]};\
			echo -e "[$$idx] $${pkg_dir}";\
	done;\
	echo -e "MEM DIRS:";\
	for idx in `seq 0 $$(($${#mem_dirs_list[@]}-1))`; do\
			mem_dir=$${mem_dirs_list[$$idx]};\
			echo -e "[$$idx] $${mem_dir}";\
	done;\
	echo -e "RTL PATHS:";\
	for idx in `seq 0 $$(($${#rtl_paths_list[@]}-1))`; do\
			rtl_path=$${rtl_paths_list[$$idx]};\
			echo -e "[$$idx] $${rtl_path}";\
	done;\
	echo -e "TOP MODULE: $(TOP_MODULE)"

#H# update-commit-file  : Update commit hash file
update-commit-file:
	@echo $(COMMIT_HASH) > $(COMMIT_FILE)

#H# update-version-file : Update version file
update-version-file:
	@echo $(VERSION) > $(VERSION_FILE)

#H# dw-commit           : Display duckWizard's commit hash
dw-commit:
	@cat $(COMMIT_FILE)

#H# dw-version          : Display duckWizard's version
dw-version:
	@cat $(VERSION_FILE)

#H# del-bak             : Delete backup files
del-bak:
	find ./* -name "*~" -delete
	find ./* -name "*.bak" -delete

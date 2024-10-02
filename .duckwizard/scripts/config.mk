### configuration input ###
CONFIG_FILE                       = $(TOP_DIR)/project.config
PARSE_CONFIG                      = $(SCRIPTS_DIR)/parse_config $(CONFIG_FILE)

### project configuration ###
PROJECT                           ?= $(shell $(PARSE_CONFIG) project)
TOP_MODULE                        ?= $(shell $(PARSE_CONFIG) rtl_top)
# - duckwizard verbose
DW_VERBOSE                        ?= $(shell $(PARSE_CONFIG) verbose)
# - project-features
RTL_LINTER                        ?= $(shell $(PARSE_CONFIG) rtl_linter)
RTL_SYN_TOOLS                     ?= $(shell $(PARSE_CONFIG) rtl_synth_tools)
SIM_TOOL                          ?= $(shell $(PARSE_CONFIG) sim_tool)
FPGA_TEST                         ?= $(shell $(PARSE_CONFIG) fpga_test)
FPGA_SIM_TEST                     ?= $(shell $(PARSE_CONFIG) fpga_sim_test)
FPGA_SIM_TOOL                     ?= $(shell $(PARSE_CONFIG) fpga_sim_tool)
# - rtl filelist
RTL_FILELIST                      ?= $(shell $(PARSE_CONFIG) rtl_filelist)
RTL_FILELIST_PREFIX               ?= $(shell $(PARSE_CONFIG) rtl_filelist_prefix)
# - skip modules
SKIP_MODULES                      ?= $(shell $(PARSE_CONFIG) skip_modules)
# - sv2v usage
USE_SV2V                          ?= $(shell $(PARSE_CONFIG) use_sv2v)
# - rtl-lint
RTL_LINTER_LICENSE                ?= $(shell $(PARSE_CONFIG) rtl_linter_license)
RTL_LINTER_REMOTE                 ?= $(shell $(PARSE_CONFIG) rtl_linter_remote)
RTL_LINTER_REMOTE_IP              ?= $(shell $(PARSE_CONFIG) rtl_linter_remote_ip)
RTL_LINTER_ENV_SOURCE             ?= $(shell $(PARSE_CONFIG) rtl_linter_env_source)
# - rtl-linter-verilator-flags
RTL_LINTER_VERILATOR_WNO_FLAGS    ?= $(shell $(PARSE_CONFIG) rtl_linter_verilator_wno_flags)
RTL_LINTER_VERILATOR_EXTRA_FLAGS  ?= $(shell $(PARSE_CONFIG) rtl_linter_verilator_extra_flags)
RTL_LINTER_VERILATOR_DEFINES      ?= $(shell $(PARSE_CONFIG) rtl_linter_verilator_defines)
# - rtl-synthesis
RTL_SYN_USES_CLK                  ?= $(shell $(PARSE_CONFIG) rtl_synth_uses_clk)
RTL_SYN_CLK_SRC                   ?= $(shell $(PARSE_CONFIG) rtl_synth_clk_src)
# - rtl-synthesis-quartus
RTL_SYN_Q_TARGET                  ?= $(shell $(PARSE_CONFIG) rtl_synth_quartus_target)
RTL_SYN_Q_DEVICE                  ?= $(shell $(PARSE_CONFIG) rtl_synth_quartus_device)
RTL_SYN_Q_CLK_MHZ                 ?= $(shell $(PARSE_CONFIG) rtl_synth_quartus_clk_mhz)
# - rtl-synthesis-yosys
RTL_SYN_Y_TARGET                  ?= $(shell $(PARSE_CONFIG) rtl_synth_yosys_target)
RTL_SYN_Y_DEVICE                  ?= $(shell $(PARSE_CONFIG) rtl_synth_yosys_device)
RTL_SYN_Y_CLK_MHZ                 ?= $(shell $(PARSE_CONFIG) rtl_synth_yosys_clk_mhz)
RTL_SYN_Y_PNR_TOOL                ?= $(shell $(PARSE_CONFIG) rtl_synth_yosys_pnr_tool)
# - sim
SIM_MODULES                       ?= $(shell $(PARSE_CONFIG) sim_modules)
SIM_CREATE_VCD                    ?= $(shell $(PARSE_CONFIG) sim_create_vcd)
SIM_OPEN_WAVE                     ?= $(shell $(PARSE_CONFIG) sim_open_wave)
# - skip sim modules
SKIP_SIM_MODULES                  ?= $(shell $(PARSE_CONFIG) skip_sim_modules)
# - sim-questasim
SIM_QUESTA_MODE                   ?= $(shell $(PARSE_CONFIG) sim_questa_mode)
SIM_QUESTA_WAVE_DO                ?= $(shell $(PARSE_CONFIG) sim_questa_wave_do)
SIM_QUESTA_CYCLES                 ?= $(shell $(PARSE_CONFIG) sim_questa_cycles)
SIM_QUESTA_VLOG_EXTRA             ?= $(shell $(PARSE_CONFIG) sim_questa_vlog_extra_flags)
SIM_QUESTA_VSIM_EXTRA             ?= $(shell $(PARSE_CONFIG) sim_questa_vsim_extra_flags)
# - fpga-test
FPGA_TOP_MODULE                   ?= $(shell $(PARSE_CONFIG) fpga_top)
FPGA_VIRTUAL_PINS                 ?= $(shell $(PARSE_CONFIG) fpga_virtual_pins)
FPGA_BOARD_TEST                   ?= $(shell $(PARSE_CONFIG) fpga_board_test)
FPGA_USES_CLOCK                   ?= $(shell $(PARSE_CONFIG) fpga_uses_clk)
FPGA_CLOCK_SRC                    ?= $(shell $(PARSE_CONFIG) fpga_clk_src)
# - fpga-test-altera
ALTERA_TARGET                     ?= $(shell $(PARSE_CONFIG) fpga_altera_target)
ALTERA_DEVICE                     ?= $(shell $(PARSE_CONFIG) fpga_altera_device)
ALTERA_PACKAGE                    ?= $(shell $(PARSE_CONFIG) fpga_altera_package)
ALTERA_MIN_TEMP                   ?= $(shell $(PARSE_CONFIG) fpga_altera_min_temp)
ALTERA_MAX_TEMP                   ?= $(shell $(PARSE_CONFIG) fpga_altera_max_temp)
ALTERA_CLOCK_MHZ                  ?= $(shell $(PARSE_CONFIG) fpga_altera_clk_mhz)
# - fpga-test-lattice
LATTICE_TARGET                    ?= $(shell $(PARSE_CONFIG) fpga_lattice_target)
LATTICE_DEVICE                    ?= $(shell $(PARSE_CONFIG) fpga_lattice_device)
LATTICE_PACKAGE                   ?= $(shell $(PARSE_CONFIG) fpga_lattice_package)
LATTICE_CLOCK_MHZ                 ?= $(shell $(PARSE_CONFIG) fpga_lattice_clk_mhz)
LATTICE_PNR_TOOL                  ?= $(shell $(PARSE_CONFIG) fpga_lattice_pnr_tool)
# - fpga-rtl-sim
FPGA_SIM_INC_MAIN_SIM_DIR         ?= $(shell $(PARSE_CONFIG) fpga_sim_inc_main_sim_dir)
FPGA_SIM_CREATE_VCD               ?= $(shell $(PARSE_CONFIG) fpga_sim_create_vcd)
FPGA_SIM_OPEN_WAVE                ?= $(shell $(PARSE_CONFIG) fpga_sim_open_wave)
# - fpga-rtl-sim-altera
FPGA_SIM_MODULES_ALTERA           ?= $(shell $(PARSE_CONFIG) fpga_sim_modules_altera)
# - fpga-rtl-sim-altera
FPGA_SIM_MODULES_LATTICE          ?= $(shell $(PARSE_CONFIG) fpga_sim_modules_lattice)

### export variables ###
#V# CONFIG_FILE                         : duckWizard's configuration file
export CONFIG_FILE
#V# PROJECT                             : Project name
export PROJECT
#V# RTL_FILELIST                        : RTL filelist location
export RTL_FILELIST
#V# RTL_FILELIST_PREFIX                 : Prefix to append (if needed) to each RTL source in the filelist (for filelist generation)
export RTL_FILELIST_PREFIX
#V# USE_SV2V                            : Enable/Disable the use of sv2v tool for systemverilog -> verilog convertion prior to the synthesis or simulation
export USE_SV2V
#V# SKIP_MODULES                        : Exclude these source files (accepts '*') for the wildcards
export SKIP_MODULES
#V# RTL_LINTER                          : Indicates the linter to use (verilator / spyglass)
export RTL_LINTER
#V# RTL_LINTER_LICENSE                  : [Lint - SpyGlass] If needed, indicate the license path
export RTL_LINTER_LICENSE
#V# RTL_LINTER_REMOTE                   : [Lint - SpyGlass] Indicate if the linting should be executed in a remote server
export RTL_LINTER_REMOTE
#V# RTL_LINTER_REMOTE_IP                : [Lint - SpyGlass] Remote server IP for the linting
export RTL_LINTER_REMOTE_IP
#V# RTL_LINTER_ENV_SOURCE               : [Lint - SpyGlass] If not empty, this variable indicates the script to "source" in the remote server for the linting
export RTL_LINTER_ENV_SOURCE
#V# RTL_LINTER_VERILATOR_WNO_FLAGS      : [Lint - Verilator] Indicate the warnings to ignore (it will be appended to -Wno-)
export RTL_LINTER_VERILATOR_WNO_FLAGS
#V# RTL_LINTER_VERILATOR_EXTRA_FLAGS    : [Lint - Verilator] Additional flags
export RTL_LINTER_VERILATOR_EXTRA_FLAGS
#V# RTL_LINTER_VERILATOR_DEFINES        : [Lint - Verilator] Add some defines
export RTL_LINTER_VERILATOR_DEFINES
#V# RTL_SYN_USES_CLK                    : [Synthesis - General] Indicate if the design uses any clock signal
export RTL_SYN_USES_CLK
#V# RTL_SYN_CLK_SRC                     : [Synthesis - General] Clock signal name (multiple are allowed)
export RTL_SYN_CLK_SRC
#V# RTL_SYN_Q_TARGET                    : [Synthesis - Quartus] Target
export RTL_SYN_Q_TARGET
#V# RTL_SYN_Q_DEVICE                    : [Synthesis - Quartus] Device
export RTL_SYN_Q_DEVICE
#V# RTL_SYN_Q_CLK_MHZ                   : [Synthesis - Quartus] Clock frequency (multiple are allowed)
export RTL_SYN_Q_CLK_MHZ
#V# RTL_SYN_Y_TARGET                    : [Synthesis - Yosys] Target
export RTL_SYN_Y_TARGET
#V# RTL_SYN_Y_DEVICE                    : [Synthesis - Yosys] Device
export RTL_SYN_Y_DEVICE
#V# RTL_SYN_Y_CLK_MHZ                   : [Synthesis - Yosys] Clock frequency (multiple are allowed)
export RTL_SYN_Y_CLK_MHZ
#V# RTL_SYN_Y_PNR_TOOL                  : [Synthesis - Yosys] Place-and-Route tool to use (nextpnr / arachne)
export RTL_SYN_Y_PNR_TOOL
#V# SKIP_SIM_MODULES                    : [Simulation - General] Skip these source code files
export SKIP_SIM_MODULES
#V# SIM_QUESTA_MODE                     : [Simulation - Questasim] GUI or Console mode, leave empty for GUI mode (-c / )
export SIM_QUESTA_MODE
#V# SIM_QUESTA_WAVE_DO                  : [Simulation - Questasim] TCL script for the waveform, path relative to tb/scripts/
export SIM_QUESTA_WAVE_DO
#V# SIM_QUESTA_CYCLES                   : [Simulation - Questasim] Simulation cycles, leave empty if no cycles limit (default: -all)
export SIM_QUESTA_CYCLES
#V# SIM_QUESTA_VLOG_EXTRA               : [Simulation - Questasim] Extra flags for vlog
export SIM_QUESTA_VLOG_EXTRA
#V# SIM_QUESTA_VSIM_EXTRA               : [Simulation - Questasim] Extra flags for vsim
export SIM_QUESTA_VSIM_EXTRA
#V# FPGA_TOP_MODULE                     : [FPGA Test - General] Top module
export FPGA_TOP_MODULE
#V# FPGA_VIRTUAL_PINS                   : [FPGA Test - General] Indicate if it uses virtual pinout (no I/O restriction)
export FPGA_VIRTUAL_PINS
#V# FPGA_BOARD_TEST                     : [FPGA Test - General] FPGA board
export FPGA_BOARD_TEST
#V# FPGA_USES_CLOCK                     : [FPGA Test - General] Indicate if the design uses a clock signal
export FPGA_USES_CLOCK
#V# FPGA_CLOCK_SRC                      : [FPGA Test - General] Clock signal name (multiple are allowed)
export FPGA_CLOCK_SRC
#V# ALTERA_TARGET                       : [FPGA Configuration - Altera] Target Altera FPGA family (e.g., Cyclone IV)
export ALTERA_TARGET
#V# ALTERA_DEVICE                       : [FPGA Configuration - Altera] Altera FPGA device ID (e.g., EP4CE22F17C6)
export ALTERA_DEVICE
#V# ALTERA_PACKAGE                      : [FPGA Configuration - Altera] Package type for the Altera FPGA (e.g., normal)
export ALTERA_PACKAGE
#V# ALTERA_MIN_TEMP                     : [FPGA Configuration - Altera] Minimum operating temperature for the Altera FPGA (°C)
export ALTERA_MIN_TEMP
#V# ALTERA_MAX_TEMP                     : [FPGA Configuration - Altera] Maximum operating temperature for the Altera FPGA (°C)
export ALTERA_MAX_TEMP
#V# ALTERA_CLOCK_MHZ                    : [FPGA Configuration - Altera] Clock frequency for the Altera FPGA (in MHz)
export ALTERA_CLOCK_MHZ
#V# LATTICE_TARGET                      : [FPGA Configuration - Lattice] Target Lattice FPGA family (e.g., ice40)
export LATTICE_TARGET
#V# LATTICE_DEVICE                      : [FPGA Configuration - Lattice] Lattice FPGA device ID (e.g., up5k)
export LATTICE_DEVICE
#V# LATTICE_PACKAGE                     : [FPGA Configuration - Lattice] Package type for the Lattice FPGA (e.g., sg48)
export LATTICE_PACKAGE
#V# LATTICE_CLOCK_MHZ                   : [FPGA Configuration - Lattice] Clock frequency for the Lattice FPGA (in MHz)
export LATTICE_CLOCK_MHZ
#V# LATTICE_PNR_TOOL                    : [FPGA Configuration - Lattice] Place-and-Route tool for Lattice FPGA (e.g., nextpnr)
export LATTICE_PNR_TOOL
#V# FPGA_SIM_MODULES_ALTERA             : [FPGA Simulation - Altera] List of top-level modules for Altera FPGA simulation
export FPGA_SIM_MODULES_ALTERA
#V# FPGA_SIM_MODULES_LATTICE            : [FPGA Simulation - Lattice] List of top-level modules for Lattice FPGA simulation
export FPGA_SIM_MODULES_LATTICE

#H# check-config        : Check project configuration
ifeq ("$(DW_VERBOSE)","yes")
check-config:
	@echo "TODO: Project configuration checker rule"
else
check-config: ;
endif

### supported stuff flags ###
SUPPORTED_SYNTHESIS  = quartus yosys
SUPPORTED_FPGA_TEST  = altera lattice
SUPPORTED_SIMULATION = iverilog questasim

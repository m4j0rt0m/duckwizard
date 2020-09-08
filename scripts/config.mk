### configuration input ###
CONFIG_FILE             = $(TOP_DIR)/project.config
PARSE_CONFIG            = $(SCRIPTS_DIR)/parse_config $(CONFIG_FILE)

### project configuration ###
PROJECT                ?= $(shell $(PARSE_CONFIG) project)
TOP_MODULE             ?= $(shell $(PARSE_CONFIG) rtl_top)
# - rtl-synthesis
RTL_SYN_TOOLS          ?= $(shell $(PARSE_CONFIG) rtl_synth_tools)
RTL_SYN_CLK_SRC        ?= $(shell $(PARSE_CONFIG) rtl_synth_clk_src)
# - rtl-synthesis-quartus
RTL_SYN_Q_TARGET       ?= $(shell $(PARSE_CONFIG) rtl_synth_quartus_target)
RTL_SYN_Q_DEVICE       ?= $(shell $(PARSE_CONFIG) rtl_synth_quartus_device)
RTL_SYN_Q_CLK_PERIOD   ?= $(shell $(PARSE_CONFIG) rtl_synth_quartus_clk_period)
# - rtl-synthesis-yosys
RTL_SYN_Y_TARGET       ?= $(shell $(PARSE_CONFIG) rtl_synth_yosys_target)
RTL_SYN_Y_DEVICE       ?= $(shell $(PARSE_CONFIG) rtl_synth_yosys_device)
RTL_SYN_Y_CLK_MHZ      ?= $(shell $(PARSE_CONFIG) rtl_synth_yosys_clk_mhz)
# - sim
SIM_MODULES            ?= $(shell $(PARSE_CONFIG) sim_modules)
SIM_TOOL               ?= $(shell $(PARSE_CONFIG) sim_tool)
SIM_CREATE_VCD         ?= $(shell $(PARSE_CONFIG) sim_create_vcd)
SIM_OPEN_WAVE          ?= $(shell $(PARSE_CONFIG) sim_open_wave)
# - fpga-test
FPGA_TOP_MODULE        ?= $(shell $(PARSE_CONFIG) fpga_top)
FPGA_VIRTUAL_PINS      ?= $(shell $(PARSE_CONFIG) fpga_virtual_pins)
FPGA_BOARD_TEST        ?= $(shell $(PARSE_CONFIG) fpga_board_test)
FPGA_CLOCK_SRC         ?= $(shell $(PARSE_CONFIG) fpga_clk_src)
FPGA_SYNTH_ALTERA      ?= $(shell $(PARSE_CONFIG) fpga_synth_altera)
FPGA_SYNTH_LATTICE     ?= $(shell $(PARSE_CONFIG) fpga_synth_lattice)
# - fpga-test-altera
ALTERA_TARGET          ?= $(shell $(PARSE_CONFIG) fpga_altera_target)
ALTERA_DEVICE          ?= $(shell $(PARSE_CONFIG) fpga_altera_device)
ALTERA_PACKAGE         ?= $(shell $(PARSE_CONFIG) fpga_altera_package)
ALTERA_MIN_TEMP        ?= $(shell $(PARSE_CONFIG) fpga_altera_min_temp)
ALTERA_MAX_TEMP        ?= $(shell $(PARSE_CONFIG) fpga_altera_max_temp)
ALTERA_CLOCK_PERIOD    ?= $(shell $(PARSE_CONFIG) fpga_altera_clk_period)
# - fpga-test-lattice
LATTICE_TARGET         ?= $(shell $(PARSE_CONFIG) fpga_lattice_target)
LATTICE_DEVICE         ?= $(shell $(PARSE_CONFIG) fpga_lattice_device)
LATTICE_PACKAGE        ?= $(shell $(PARSE_CONFIG) fpga_lattice_package)
LATTICE_CLOCK_MHZ      ?= $(shell $(PARSE_CONFIG) fpga_lattice_clk_mhz)

### export variables ###
export CONFIG_FILE
export PROJECT
export RTL_SYN_CLK_SRC
export RTL_SYN_Q_TARGET
export RTL_SYN_Q_DEVICE
export RTL_SYN_Q_CLK_PERIOD
export RTL_SYN_Y_TARGET
export RTL_SYN_Y_DEVICE
export RTL_SYN_Y_CLK_MHZ
export FPGA_TOP_MODULE
export FPGA_VIRTUAL_PINS
export FPGA_BOARD_TEST
export FPGA_CLOCK_SRC
export ALTERA_TARGET
export ALTERA_DEVICE
export ALTERA_PACKAGE
export ALTERA_MIN_TEMP
export ALTERA_MAX_TEMP
export ALTERA_CLOCK_PERIOD
export LATTICE_TARGET
export LATTICE_DEVICE
export LATTICE_PACKAGE
export LATTICE_CLOCK_MHZ

#H# check-config        : Check project configuration
check-config:
	@echo "TODO: Project configuration checker rule"

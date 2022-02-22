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

### check sv2v
ifeq (, $(shell which sv2v))
SV2V_IN_PATH:=false
else
SV2V_IN_PATH:=true
endif

#H# print-rtl-srcs  : Print RTL sources
print-rtl-srcs:
	$(call print-srcs-command)

#H# check-sv2v      : Check if sv2v tool is installed
check-sv2v:
	@if [[ "$(SV2V_IN_PATH)" != true ]]; then\
		echo " [!] sv2v is not installed nor in PATH, running install-helper...";\
		$(MAKE) install-sv2v;\
	fi

#H# install-sv2v    : Install sv2v tool (SystemVerilog to Verilog code conversion tool)
install-sv2v:
	@$(SCRIPTS_DIR)/install-sv2v

### function define: veritedium AUTO directive ###
define veritedium-command
emacs --batch $(1) -f verilog-auto -f save-buffer >/dev/null 2>&1;
endef

### function define: print sources ###
define print-srcs-command
	@echo -e "$(_info_)\n[INFO] RTL Source Files$(_reset_)";\
	echo -e "$(_segment_)"
	@echo " [+] Verilog Source Files: $(words $(VERILOG_SRC))";\
	for vsrc in $(VERILOG_SRC);\
	do\
		echo "  |-> $${vsrc}";\
	done
	@echo " [+] Verilog Headers Files: $(words $(VERILOG_HEADERS))";\
	for vheader in $(VERILOG_HEADERS);\
	do\
		echo "  |-> $${vheader}";\
	done
	@echo " [+] Packages Source Files: $(words $(PACKAGE_SRC))";\
	for psrc in $(PACKAGE_SRC);\
	do\
		echo "  |-> $${psrc}";\
	done
	@echo " [+] Memory Source Files: $(words $(MEM_SRC))";\
	for msrc in $(MEM_SRC);\
	do\
		echo "  |-> $${msrc}";\
	done;\
	echo -e "$(_reset_)"
endef

### function define: print filelist ###
define print-filelist
	@> $(1);\
	for idir in $(INCLUDE_DIRS);\
	do\
		{ echo '+incdir+$${DESIGN_RTL_DIR}/'; echo "$${idir}" | grep -oP "^$(2)/\K.*";} | tr -d "\n"  >> $(1);\
		echo "" >> $(1);\
	done;\
	for psrc in $(PACKAGE_SRC);\
	do\
		{ echo '$${DESIGN_RTL_DIR}/'; echo "$${psrc}" | grep -oP "^$(2)/\K.*";} | tr -d "\n" >> $(1);\
		echo "" >> $(1);\
	done;\
	for vsrc in $(VERILOG_SRC);\
	do\
		{ echo '$${DESIGN_RTL_DIR}/'; echo "$${vsrc}" | grep -oP "^$(2)/\K.*";} | tr -d "\n" >> $(1);\
		echo "" >> $(1);\
	done
endef

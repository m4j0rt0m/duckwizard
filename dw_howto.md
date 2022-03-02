# How to use duckWizard in your own project

* Clone from www.github.com/m4j0rt0m/duckwizard
* Remove .git directory.f
* Replace LICENSE from the root dir with your own LICENSE file
* Add your source code in:
  * ./src -> Main source code directory (rtl, include, package, etc.)
  * ./tb -> Main testbench source code directory
* Modify project.config
* If it's required to convert from SystemVerilog to Verilog (for free eda tools)
  * make install-sv2v (if sv2v not installed)
  * change the option in project.config -> [*] use_sv2v = yes
* Synthesis:
  * make rtl-synth
* Simulation:
  * make rtl-sim

# RTL Development Template

Before using the template, fill the feature lists in ***project.config*** and run:
```
make env-dirs
```
It will create the feature's directories depending on the filled information in ***project.config*** file.

### Overview
This is an RTL development tool that handles the processes of HDL linting, synthesis, simulation and FPGA tests automatically. It's scalable, user friendly and easy to port to your own project.

### Divide and conquer
The main goal of this tool is to have a complete distributed and well organized project structure for an out-of-the-box RTL development environment. The main source code should be allocated under the ***"src"*** directory (under this directory you can also include several subprojects with their own development environment), while the main processes *(synthesis, simulation, fpga test)* stuff are distributed and allocated under their respectively directories.

### The single configuration file to fill
In order to automatize the processes, the ***project.config*** file contains all the necessary information, we can select which code linter to use, include the Project name, as well as the Top module (or a set of Top modules if wanting to synthesize for multiple targets), also, select the synthesis tool to use (and its configurations... device, target, clock frequency for clock contraints, etc.), simulation tool to use and FPGA test configuration options, more options can be included as needed. This is the only stuff to fill in order to start coding and testing your RTL code.

*... Although, setting the appropiate flags found in* ***script/config.mk*** *can bypass the project configuration file information (this can be useful in CI/CD tasks).*

### One Makefile to rule them all... almost
The main Makefile is allocated in the root directory and is in charge of reading the project configuration file, extract the information from it, create the source wildcards and communicate with the different processes environments (linting, synthesis, simulation, fpga test, etc.).

- This Makefile is scalable and more targets and processes can be added to it easily, the already written jobs can be used as a guide for it.
- If using an external library, the path(s) can be included setting the ***EXT_LIB_SOURCE_DIR*** variable.
- If you need help in order to know what command to run ***"make help"*** is your friend.

### Support
As this is a work-in-progress project, more useful stuff will be added time to time to it, although, it can already be used for several projects:
- Linting
  - Verilator
  - SpyGlass
- Synthesis
  - Quartus
  - Yosys
- Simulation
  - Icarus Verilog
- FPGA test
  - Altera
  - Lattice

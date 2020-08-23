LibreCores CI Base Image for Docker
====

[![Docker Pulls](https://img.shields.io/docker/pulls/librecores/ci.svg)](https://hub.docker.com/r/librecores/ci/)

This is a base image which includes common EDA tools.

### Included tools

* [FuseSoC](https://fusesoc.net/) - Build system and EDA tool orchestration
* [Icarus Verilog](http://iverilog.icarus.com) - verilog simulation
* [Verilator](https://www.veripool.org/wiki/verilator) - verilog simulation
* [Verible](https://www.veripool.org/wiki/verilator) - verilog simulation
* [Yosys](http://www.clifford.at/yosys/) - for verilog synthesis
* [cocotb](https://github.com/potentialventures/cocotb) - write verilog testbenchs in python
* [pytest](https://docs.pytest.org/en/latest/) - generic python testing
  framework
* [tap.py](https://pypi.org/project/tap.py/) - python support for [TAP](http://testanything.org)

### Versions

#### 2020.6

- cocotb: 1.3.1
- FuseSoC: 1.10
- Icarus Verilog: 10.3
- pytest: 5.4.3
- tap.py: 3.0
- Verible: 0.0-440-gb3da8ae
- Verilator: 4.036
- Yosys: 0.9

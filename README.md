# UCSB ECE594BB S21 Team4 Final Project: Time Domain SNN Inference Acceleration/Optimization

## Instructions for use
### Windows

These instructions require administrator access on your host computer.

1. If not already done, install [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/install-win10).
2. If not already done, install [Ubuntu 20.04 from the Microsoft Windows Store](https://www.microsoft.com/en-us/p/ubuntu-2004-lts/9n6svws3rx71).
3. Open the Start menu and type `Ubuntu 20.04 LTS`. Select the app with the orange logo.
4. If not already done, setup your Ubuntu account.
5. Follow the Ubuntu 20.04 instructions in the given shell.

### Ubuntu 20.04

These instructions require administrator access on your host computer, unless iverilog and numpy are already installed.

1. Install Icarus Verilog 10.3 (stable) with the command `sudo apt-get install iverilog`.
2. Install NumericPython with the command `python3 -m pip install numpy`.
3. Change directory to the root of this project. (The files `makefile` and `net.v` should be visible in the list generated by `ls`.)
4. Run `make tests` to run validation tests on all modules. The words `error` and `FAIL` should not appear in the output.
5. Run `make netwaves` to use the weights in `trained_weights.mem` and input binary images in `v0.im` and `v1.im` to generate VCD waveforms `waves/v0.vcd` and `waves/v1.vcd`.
6. Run `make activity_data` to extract a count of how many times each line switches over the course of the simulation, following the initial reset phase.

GNU `make` will list all commands it runs to accomplish each operation as it runs them.

## Project Layout

The `lib` directory contains Verilog components used in the project. The `tests` directory contains tests for these units. The automatically generated `build` and `waves` directories contain compiled Verilog and simulation result Value Change Dump files respectively.

`net.v` assembles the top-level network, loads the weights from a weights file given by the macro `WEIGHTFILE`, loads the input spike trains given by the macro `INPUTFILE`, then saves a dump of all variable waveforms to the location in macro `OUTFILE`.

## Testbench format

All testbenches take the macro `OUTFILE` for a location to write their Value Change Dump (VCD) files.

Most testbenches check their own output for errors and report them with the `$error` function if found.

## File Formats

+ `*.im` files are assumed to be 5x5 binary images recorded as `1` and `0` characters in ascii text -- five rows of five characters each, newline separated.
    + `seq_mem_gen.py` converts these images to spike trains across all input neurons. To adjust the spike trains for `1`s or `0`s in the image, adjust the corresponding sequence variable in `seq_mem_gen.py`. The length of the input sequence is assumed by `net.v` to be 20 timesteps.
+ `trained_weights.mem` is a Verilog memb memory file with four rows of 25 bits each. The rows, in order, represent:
    + The ones-place weight bits of Neuron 1
    + The twos-place weight bits of Neuron 1
    + The ones-place weight bits of Neuron 2
    + The twos-place weight bits of Neuron 2
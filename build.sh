#!/bin/bash
set -e

if [[ $(uname) == "Linux" ]]; then
    if [[ $(id -u) == 0 ]]; then
        apt-get update
        apt-get install -y autoconf build-essential cmake curl gperf git libgmp-dev python-is-python3 wget
    fi
else
    echo "Currently, installing on Linux (Ubuntu/Centos/AL2) is only supported."
    exit 1
fi


# Build and install dependencies
pushd .
cd deps
rm -rf boolector btor2tools mathsat yices2
./build_deps.sh
cd ..
popd


# Build AVR source
pushd .
cd src
make clean
make -j$(nproc) all
cd ..
popd


# Test AVR

python avr.py -n test_vmt          examples/vmt/counter.smt2
python avr.py -n test_vmt2         examples/vmt/simple.c.vmt
python avr.py -n test_btor2        examples/btor2/counter.btor2
python avr.py -n test_verilog      examples/verilog/counter.v        # requires yosys
python avr.py -n test_verilog_aig  examples/verilog/counter.v --aig  # requires yosys


RETURN="$?"
if [ "${RETURN}" != "0" ]; then
    echo "Installing dependencies failed."
    exit 1
fi

#!/bin/bash
set -e


# Build and install dependencies
pushd .
cd deps
./build_deps.sh
cd ..
popd


# Build AVR source
pushd .
cd src
make -j$(nproc) all
echo "#define BACKEND_BT" > reach/reach_backend_config.h
make BIN_DIR=$(pwd)/../build/bin_bt_cad -j$(nproc) all
echo "#define BACKEND_M5" > reach/reach_backend_config.h
make BIN_DIR=$(pwd)/../build/bin_msat -j$(nproc) all
echo "#define BACKEND_Y2" > reach/reach_backend_config.h
cd ..
popd


# Test AVR

python avr.py -n test_vmt          examples/vmt/counter.smt2
python avr.py -n test_vmt2         examples/vmt/simple.c.vmt
python avr.py -n test_btor2        examples/btor2/counter.btor2
# python avr.py -n test_verilog      examples/verilog/counter.v        # requires yosys
# python avr.py -n test_verilog_aig  examples/verilog/counter.v --aig  # requires yosys


RETURN="$?"
if [ "${RETURN}" != "0" ]; then
    echo "Installing dependencies failed."
    exit 1
fi

#!/bin/bash
echo "Building nvtop"
mkdir build
cd build
cmake .. -DNVIDIA_SUPPORT=ON
make
echo "Built nvtop"
#bash gen-rpm.sh -d
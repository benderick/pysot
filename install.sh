#!/bin/bash

if [ $# -lt 1 ]; then
    echo "ARGS ERROR!"
    echo "  bash install.sh env_name"
    exit 1
fi

dir=$(basename "$PWD")

if [ "$dir" == "pysot" ]; then
    echo "Running in the pysot directory"
else
    echo "Not in the pysot directory"
    exit 1
fi

set -e

env_name=$1

echo "****** create environment " $env_name "*****"
# create environment
conda create -y --name $env_name python=3.7
conda activate $env_name

echo "***** install numpy pytorch opencv *****"
# numpy
conda install -y "numpy<1.24"
# pytorch
conda install -y pytorch==1.10.1 torchvision==0.11.2 torchaudio==0.10.1 cudatoolkit=11.3 -c pytorch -c conda-forge

# install other libs
echo "***** install other libs *****"
pip install -r requirements.txt


echo "***** build extensions *****"
cp toolkit/utils/c_region.pxd .
python setup.py build_ext --inplace
rm c_region.pxd

echo "***** install self in editable way *****"
pip install -e .

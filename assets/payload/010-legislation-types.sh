#!/bin/bash
mkdir -p /ConnectedGovernment/Raw
python 010-legislation-types.py > /ConnectedGovernment/Raw/010-legislation-types.csv
sed -i '/#browse/d' /ConnectedGovernment/Raw/010-legislation-types.csv
cat /ConnectedGovernment/Raw/010-legislation-types.csv 

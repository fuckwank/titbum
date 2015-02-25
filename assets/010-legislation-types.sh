#!/bin/bash
python 010-legislation-types.py > 010-legislation-types.csv
sed -i '/#browse/d' 010-legislation-types.csv
cat 010-legislation-types.csv 

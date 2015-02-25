#!/bin/bash
mkdir -p /ConnectedGovernment/Raw
python 010-legislation-types.py > /ConnectedGovernment/Raw/010-legislation-types.csv
sed -i '/#browse/d' /ConnectedGovernment/Raw/010-legislation-types.csv
cat /ConnectedGovernment/Raw/010-legislation-types.csv 

cat /ConnectedGovernment/Raw/010-legislation-types.csv | while read line
do
   echo "$line" > /tmp/Current-legislation-type
   Current_legislation_type_url=$(awk -F"," '{print $1}' /tmp/Current-legislation-type)
   Current_legislation_type_name=$(awk -F"," '{print $2}' /tmp/Current-legislation-type)
   echo "ConnectedGovernment: $Current_legislation_type_name: Createing project"
   gitlab create_group $(echo "$Current_legislation_type_name" | tr ' ' '_') $(echo "$Current_legislation_type_name" | tr ' ' '_')
   sleep 5s
   echo "ConnectedGovernment: $Current_legislation_type_name: Created project"
done


mkdir -p /ConnectedGovernment/Gitlab
gitlab groups > /ConnectedGovernment/Gitlab/010-legislation-types

cat /ConnectedGovernment/Raw/010-legislation-types.csv | while read line
do
   echo "$line" > /tmp/Current-legislation-type
   Current_legislation_type_url=$(awk -F"," '{print $1}' /tmp/Current-legislation-type)
   Current_legislation_type_name=$(awk -F"," '{print $2}' /tmp/Current-legislation-type)
   echo "ConnectedGovernment: $Current_legislation_type_name: Getting ID"
   Current_legislation_type_id=$(cat /ConnectedGovernment/Gitlab/010-legislation-types | grep -E "(^|\s)$(echo "$Current_legislation_type_name" | tr ' ' '_')($|\s)" | awk '{print $3;}')
   echo "ConnectedGovernment: $Current_legislation_type_name: ID=$Current_legislation_type_id"
done

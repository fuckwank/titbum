#!/bin/bash
mkdir -p /ConnectedGovernment/Raw
mkdir -p /ConnectedGovernment/Gitlab

python 010-legislation-types.py > /ConnectedGovernment/Raw/010-legislation-types.csv
sed -i '/#browse/d' /ConnectedGovernment/Raw/010-legislation-types.csv
cat /ConnectedGovernment/Raw/010-legislation-types.csv 

touch /ConnectedGovernment/Gitlab/010-legislation-types
cat /ConnectedGovernment/Raw/010-legislation-types.csv | while read line
do
   echo "$line" > /tmp/Current-legislation-type
   Current_legislation_type_url=$(awk -F"," '{print $1}' /tmp/Current-legislation-type)
   Current_legislation_type_name=$(awk -F"," '{print $2}' /tmp/Current-legislation-type)
   Current_legislation_type_name_safe=$(echo "$Current_legislation_type_name" | sed -e 's/^[ \t]*//' | tr ' ' '_')
   echo "ConnectedGovernment: $Current_legislation_type_name: Createing project"
   Current_legislation_type_id=$(gitlab create_group $Current_legislation_type_name_safe $Current_legislation_type_name_safe | grep -E "(^|\s)$(echo "id" | tr ' ' '_')($|\s)" | awk '{print $4;}')
   Current_legislation_type_slug=$(echo $Current_legislation_type_url | sed 's/http:\/\/www.legislation.gov.uk\///')
   echo $Current_legislation_type_name_safe $Current_legislation_type_id $Current_legislation_type_slug >> /ConnectedGovernment/Gitlab/010-legislation-types
   cat /ConnectedGovernment/Gitlab/010-legislation-types
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

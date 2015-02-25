#/bin/bash
set -e


OutputRootDir="/ConnectedGovernment/Raw"


Current_legislation_type_url=$(awk -F"," '{print $1}' /tmp/Current-legislation-type)
Current_legislation_type_name=$(awk -F"," '{print $2}' /tmp/Current-legislation-type)
Current_legislation_type_name=$(awk -F"," '{print $3}' /tmp/Current-legislation-type)

echo "$Current_legislation_type_url"
echo "$Current_legislation_type_name"
echo "$Current_legislation_type_slug"



LegislationType="ukpga"
LegislationYear="2014"
LegislationVolume="24"


LegislationTitle=$(python 039-act-name.py $LegislationType $LegislationYear $LegislationVolume | tr ' ' '_')

if [ "$LegislationTitle" != "404_error" ]; then
  
  echo "ConnectecdGovernment: $LegislationTitle found"
  LegislationOutputDir="$OutputRootDir/$LegislationType/$LegislationTitle"

  echo "ConnectecdGovernment: $LegislationTitle: Making output directory at $LegislationOutputDir"
  mkdir -p $LegislationOutputDir
  
  LegislationSection="introduction"
  echo "ConnectecdGovernment: $LegislationTitle: Getting legislation $LegislationSection"
  python 040-act.py $LegislationType $LegislationYear $LegislationVolume 0 | html2text > $LegislationOutputDir/$LegislationSection.md
  if [ "$(cat $LegislationOutputDir/$LegislationSection.md | awk '{print $1}')" != "404" ]; then
    echo "ConnectecdGovernment: $LegislationTitle: Got legislation $LegislationSection, saved at $LegislationOutputDir/$LegislationSection.md"
  else
    echo "ConnectecdGovernment: $LegislationTitle: No legislation $LegislationSection, cleaning up repo"
    rm -f $LegislationOutputDir/$LegislationSection.md
  fi
  
  LegislationSection="body"
  echo "ConnectecdGovernment: $LegislationTitle: Getting legislation $LegislationSection"
  python 040-act.py $LegislationType $LegislationYear $LegislationVolume 1 | html2text > $LegislationOutputDir/$LegislationSection.md
  if [ "$(cat $LegislationOutputDir/$LegislationSection.md | awk '{print $1}')" != "404" ]; then
    echo "ConnectecdGovernment: $LegislationTitle: Got legislation $LegislationSection, saved at $LegislationOutputDir/$LegislationSection.md"
  else
    echo "ConnectecdGovernment: $LegislationTitle: No legislation $LegislationSection, cleaning up repo"
    rm -f $LegislationOutputDir/$LegislationSection.md
  fi
  
  LegislationSection="schedules"
  echo "ConnectecdGovernment: $LegislationTitle: Getting legislation $LegislationSection"
  python 040-act.py $LegislationType $LegislationYear $LegislationVolume 2 | html2text > $LegislationOutputDir/$LegislationSection.md
  if [ "$(cat $LegislationOutputDir/$LegislationSection.md | awk '{print $1}')" != "404" ]; then
    echo "ConnectecdGovernment: $LegislationTitle: Got legislation $LegislationSection, saved at $LegislationOutputDir/$LegislationSection.md"
  else
    echo "ConnectecdGovernment: $LegislationTitle: No legislation $LegislationSection, cleaning up repo"
    rm -f $LegislationOutputDir/$LegislationSection.md
  fi
  
else
  echo "ConnectecdGovernment: No legislation found"
fi

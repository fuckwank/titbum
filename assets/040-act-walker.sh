#/bin/bash
set -e


OutputRootDir="/ConnectedGovernment/Raw"

LegislationType="ukpga"
LegislationYear="2014"
LegislationVolume="14"


LegislationTitle=$(python 039-act-name.py $LegislationType $LegislationYear $LegislationVolume | tr ' ' '_')

if [ "$LegislationTitle" != "404_error" ]; then
  
  echo "ConnectecdGovernment: $LegislationTitle found"
  LegislationOutputDir="$OutputRootDir/$LegislationType/$LegistationTitle"
  
  echo "ConnectecdGovernment: Making output directory at $LegislationOutputDir"
  mkdir -p $LegislationOutputDir
  
  echo "ConnectecdGovernment: Getting legislation introduction"
  python 040-act.py $LegislationType $LegislationYear $LegislationVolume 0 | html2text > $LegislationOutputDir/intro.md
  
  echo "ConnectecdGovernment: Getting legislation body"
  python 040-act.py $LegislationType $LegislationYear $LegislationVolume 1 | html2text > $LegislationOutputDir/body.md
  
  echo "ConnectecdGovernment: Getting legislation schedules"
  python 040-act.py $LegislationType $LegislationYear $LegislationVolume 2 | html2text > $LegislationOutputDir/schedules.md
  
else
  
  echo "ConnectecdGovernment: No legislation found"

fi

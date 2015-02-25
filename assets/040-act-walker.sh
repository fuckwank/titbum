#/bin/bash
set -e


OutputRootDir="/ConnectedGovernment/Raw"

LegislationType="ukpga"
LegislationYear="2014"
LegislationVolume="20"


LegislationTitle=$(python 039-act-name.py $LegislationType $LegislationYear $LegislationVolume | tr ' ' '_')

if [ "$LegislationTitle" != "404_error" ]; then
  
  echo "ConnectecdGovernment: $LegislationTitle found"
  LegislationOutputDir="$OutputRootDir/$LegislationType/$LegislationTitle"
  echo $LegislationOutputDir
  echo "ConnectecdGovernment: Making output directory at $LegislationOutputDir"
  mkdir -p $LegislationOutputDir
  
  echo "ConnectecdGovernment: Getting legislation introduction"
  python 040-act.py $LegislationType $LegislationYear $LegislationVolume 0 | html2text > $LegislationOutputDir/intro.md
  if [ "$schedules" != "404_error" ]; then
    echo "ConnectecdGovernment: Got legislation introduction, saved at $LegislationOutputDir/introduction.md"
  else
    echo "ConnectecdGovernment: No legislation introduction, cleaning up"
    rm -f $LegislationOutputDir/introduction.md
  fi
  
  echo "ConnectecdGovernment: Getting legislation body"
  python 040-act.py $LegislationType $LegislationYear $LegislationVolume 1 | html2text > $LegislationOutputDir/body.md
  if [ "$schedules" != "404_error" ]; then
    echo "ConnectecdGovernment: Got legislation body, saved at $LegislationOutputDir/body.md"
  else
    echo "ConnectecdGovernment: No legislation body, cleaning up"
    rm -f $LegislationOutputDir/body.md
  fi
  
  echo "ConnectecdGovernment: Getting legislation schedules"
  python 040-act.py $LegislationType $LegislationYear $LegislationVolume 2 | html2text > $LegislationOutputDir/schedules.md
  if [ "$schedules" != "404_error" ]; then
    echo "ConnectecdGovernment: Got legislation schedules, saved at $LegislationOutputDir/schedules.md"
  else
    echo "ConnectecdGovernment: No legislation schedules, cleaning up"
    rm -f $LegislationOutputDir/schedules.md
  fi
  
else
  echo "ConnectecdGovernment: No legislation found"
fi

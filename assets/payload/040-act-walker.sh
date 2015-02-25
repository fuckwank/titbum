#/bin/bash
set -e


OutputRootDir="/ConnectedGovernment/Raw"

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

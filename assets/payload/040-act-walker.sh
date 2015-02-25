#/bin/bash
set -e

OutputRootDir="/ConnectedGovernment/Raw"

mkdir -p $OutputRootDir

START=20
END=30
for i in $(seq $START $END); do

  cat /ConnectedGovernment/Gitlab/010-legislation-types | while read line
  do
    Current_legislation_type_name_safe=$(echo $line | awk '{print $1;}')
    Current_legislation_type_id=$(echo $line | awk '{print $2;}')
    Current_legislation_type_slug=$(echo $line | awk '{print $3;}')
    #echo $Current_legislation_type_slug $Current_legislation_type_id $Current_legislation_type_name_safe
    
    LegislationType="$Current_legislation_type_slug"
    LegislationYear="2014"
    LegislationVolume="$i"
    
    
    LegislationTitle=$(python 039-act-name.py $LegislationType $LegislationYear $LegislationVolume | tr ' ' '_' | tr '(' '_' | tr ')' '_' | tr '.' '_')
    
    if [ "$LegislationTitle" != "404_error" ]; then
      
      echo "ConnectecdGovernment: $Current_legislation_type_name_safe: $LegislationTitle found"
      LegislationOutputDir="$OutputRootDir/$LegislationType/$LegislationTitle"
    
      echo "ConnectecdGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Making output directory at $LegislationOutputDir"
      mkdir -p $LegislationOutputDir
      
      echo "# $LegislationTitle" > $LegislationOutputDir/README.md
      echo " " >> $LegislationOutputDir/README.md
      
      LegislationSection="introduction"
      echo "ConnectecdGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Getting legislation $LegislationSection"
      python 040-act.py $LegislationType $LegislationYear $LegislationVolume 0 | html2text > $LegislationOutputDir/$LegislationSection.md
      if [ "$(cat $LegislationOutputDir/$LegislationSection.md | awk '{print $1}')" != "404" ]; then
        echo "ConnectecdGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Got legislation $LegislationSection, saved at $LegislationOutputDir/$LegislationSection.md"
        echo "[$LegislationSection]($LegislationSection.md)" >> $LegislationOutputDir/README.md
      else
        echo "ConnectecdGovernment: $Current_legislation_type_name_safe: $LegislationTitle: No legislation $LegislationSection, cleaning up repo"
        rm -f $LegislationOutputDir/$LegislationSection.md
      fi
      
      LegislationSection="body"
      echo "ConnectecdGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Getting legislation $LegislationSection"
      python 040-act.py $LegislationType $LegislationYear $LegislationVolume 1 | html2text > $LegislationOutputDir/$LegislationSection.md
      if [ "$(cat $LegislationOutputDir/$LegislationSection.md | awk '{print $1}')" != "404" ]; then
        echo "ConnectecdGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Got legislation $LegislationSection, saved at $LegislationOutputDir/$LegislationSection.md"
        echo "[$LegislationSection]($LegislationSection.md)" >> $LegislationOutputDir/README.md
      else
        echo "ConnectecdGovernment: $Current_legislation_type_name_safe: $LegislationTitle: No legislation $LegislationSection, cleaning up repo"
        rm -f $LegislationOutputDir/$LegislationSection.md
      fi
      
      LegislationSection="schedules"
      echo "ConnectecdGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Getting legislation $LegislationSection"
      python 040-act.py $LegislationType $LegislationYear $LegislationVolume 2 | html2text > $LegislationOutputDir/$LegislationSection.md
      if [ "$(cat $LegislationOutputDir/$LegislationSection.md | awk '{print $1}')" != "404" ]; then
        echo "ConnectecdGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Got legislation $LegislationSection, saved at $LegislationOutputDir/$LegislationSection.md"
        echo "[$LegislationSection]($LegislationSection.md)" >> $LegislationOutputDir/README.md
      else
        echo "ConnectecdGovernment: $Current_legislation_type_name_safe: $LegislationTitle: No legislation $LegislationSection, cleaning up repo"
        rm -f $LegislationOutputDir/$LegislationSection.md
      fi
      
      Current_legislation_id=$(gitlab create_project $LegislationTitle | grep -E "(^|\s)$(echo "id" | tr ' ' '_')($|\s)" | awk '{print $4;}')
  
      gitlab transfer_project_to_group "$Current_legislation_type_id" "$Current_legislation_id"
      
      script_dir=$(pwd)
      cd $LegislationOutputDir
      git init
      git add .
      git commit -m "first commit"
      git remote add origin ssh://git@connectedgovernment.uk:10022/$Current_legislation_type_name_safe/$( echo $LegislationTitle | tr '[:upper:]' '[:lower:]').git
      git push -u origin master
      cd $script_dir
      
    else
      echo "ConnectecdGovernment: $Current_legislation_type_name_safe: No legislation found"
    fi
    
    sleep 1s
    
  done

  sleep 1s
  
done

#/bin/bash
set -e

OutputRootDir="/ConnectedGovernment/Raw"

mkdir -p $OutputRootDir

CurrentLegislationYearSTART=2015
CurrentLegislationYearEND=2015
CurrentLegislationVolumeSTART=1
CurrentLegislationVolumeEND=20

for CurrentLegislationYear in $(seq $CurrentLegislationYearSTART $CurrentLegislationYearEND); do

  for CurrentLegislationVolume in $(seq $CurrentLegislationVolumeSTART $CurrentLegislationVolumeEND); do
  
    cat /ConnectedGovernment/Gitlab/010-legislation-types | while read line
    do
      Current_legislation_type_name_safe=$(echo $line | awk '{print $1;}')
      Current_legislation_type_id=$(echo $line | awk '{print $2;}')
      Current_legislation_type_slug=$(echo $line | awk '{print $3;}')
      #echo $Current_legislation_type_slug $Current_legislation_type_id $Current_legislation_type_name_safe
      
      LegislationType="$Current_legislation_type_slug"
      LegislationYear="$CurrentLegislationYear"
      LegislationVolume="$CurrentLegislationVolume"
      
      LegislationTitleFull=$( python 039-act-name.py $LegislationType $LegislationYear $LegislationVolume )      
      LegislationTitle=$( $LegislationTitleFull | tr -d -c ".[:alnum:]" )

      if [ "$LegislationTitle" != "404_error" ]; then
        
        echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle found"
        LegislationOutputDir="$OutputRootDir/$LegislationType/$LegislationTitle"
      
        echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Making output directory at $LegislationOutputDir"
        mkdir -p $LegislationOutputDir
        
        echo "# $LegislationTitleFull" > $LegislationOutputDir/README.md
        echo "---" >> $LegislationOutputDir/README.md
        echo "Welcome to the [ConnectedGovernment](http://connectedgovernment.uk/help) archive of the $LegislationTitleFull." >> $LegislationOutputDir/README.md
        echo "" >> $LegislationOutputDir/README.md
        
        LegislationSection="introduction"
        echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Getting legislation $LegislationSection"
        python 040-act.py $LegislationType $LegislationYear $LegislationVolume 0 | html2text > $LegislationOutputDir/$LegislationSection.md
        if [ "$(cat $LegislationOutputDir/$LegislationSection.md | awk '{print $1}')" != "404" ]; then
          echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Got legislation $LegislationSection, saved at $LegislationOutputDir/$LegislationSection.md"
          
          echo "The legislation has been collated into the files bellow:" >> $LegislationOutputDir/README.md
          
          echo "This legislation describes itself as:" >> $LegislationOutputDir/README.md 
          echo "" >> $LegislationOutputDir/README.md
          
          cat $LegislationOutputDir/$LegislationSection.md | sed '/^#/d' | sed '${/]/d;}' | sed '0{/]/d;}' | sed 's/^/>/' >> $LegislationOutputDir/README.md

          echo " * [Legislation $LegislationSection]($LegislationSection.md)" >> $LegislationOutputDir/README.md
        else
          echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: No legislation $LegislationSection, cleaning up repo"
          rm -f $LegislationOutputDir/$LegislationSection.md
        fi
        
        
        LegislationSection="body"
        echo "ConnectecdGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Getting legislation $LegislationSection"
        python 040-act.py $LegislationType $LegislationYear $LegislationVolume 1 | html2text > $LegislationOutputDir/$LegislationSection.md
        if [ "$(cat $LegislationOutputDir/$LegislationSection.md | awk '{print $1}')" != "404" ]; then
          echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Got legislation $LegislationSection, saved at $LegislationOutputDir/$LegislationSection.md"
          echo " * [Legislation $LegislationSection]($LegislationSection.md)" >> $LegislationOutputDir/README.md
        else
          echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: No legislation $LegislationSection, cleaning up repo"
          rm -f $LegislationOutputDir/$LegislationSection.md
        fi
        
        LegislationSection="schedules"
        echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Getting legislation $LegislationSection"
        python 040-act.py $LegislationType $LegislationYear $LegislationVolume 2 | html2text > $LegislationOutputDir/$LegislationSection.md
        if [ "$(cat $LegislationOutputDir/$LegislationSection.md | awk '{print $1}')" != "404" ]; then
          echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Got legislation $LegislationSection, saved at $LegislationOutputDir/$LegislationSection.md"
          echo " * [Legislation $LegislationSection]($LegislationSection.md)" >> $LegislationOutputDir/README.md
        else
          echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: No legislation $LegislationSection, cleaning up repo"
          rm -f $LegislationOutputDir/$LegislationSection.md
        fi
        
        echo " " >> $LegislationOutputDir/README.md
        echo "There may also be addional supporting material held within the archive." >> $LegislationOutputDir/README.md
        echo " " >> $LegislationOutputDir/README.md
        echo "---" >> $LegislationOutputDir/README.md
        echo "### Please Note:" >> $LegislationOutputDir/README.md
        echo " " >> $LegislationOutputDir/README.md
        echo "This archive contains material published under the [Open Government Licence](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/) and is made from publicly avalible information. Any information submitted to this archive will be held under either the [Open Government Licence](https://www.nationalarchives.gov.uk/doc/open-government-licence/version/) or the CC-BY-SA Licence as appropriate." >> $LegislationOutputDir/README.md
        
        echo "ConnectedGovernment: Creating project on git host for $LegislationTitleFull"
        Current_legislation_id=$(gitlab create_project $LegislationTitle | grep -E "(^|\s)$(echo "id" | tr ' ' '_')($|\s)" | awk '{print $4;}')
        
        echo "ConnectedGovernment: Transfering $LegislationTitleFull project to the $Current_legislation_type_name_safe group"
        gitlab transfer_project_to_group "$Current_legislation_type_id" "$Current_legislation_id"
        
        echo "ConnectedGovernment: Creating git repo to house $LegislationTitleFull"
        script_dir=$(pwd)
        cd $LegislationOutputDir
        git init
        
        echo "ConnectedGovernment: Adding files to $LegislationTitleFull repo"
        git add .
        git commit -m "Legislation added from upstream source"
        
        echo "ConnectedGovernment: Adding orgin to $LegislationTitleFull repo"
        git remote add origin ssh://git@connectedgovernment.uk:10022/$Current_legislation_type_name_safe/$( echo $LegislationTitle | tr '[:upper:]' '[:lower:]').git
        
        echo "ConnectedGovernment: Pushing $LegislationTitleFull repo to the server"
        git push -u origin master
        cd $script_dir
        
      else
        echo "ConnectedGovernment: $Current_legislation_type_name_safe: No legislation found"
      fi
      
    done
  
  done

done

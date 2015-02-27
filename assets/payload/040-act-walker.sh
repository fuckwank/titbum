#/bin/bash
set -e

OutputRootDir="/ConnectedGovernment/Raw"

export LOG="/ConnectedGovernment/Gitlab/040-legislation-repos-($(echo \"date --iso-8601='seconds'\" | tr -d -c ".[:alnum:]")).csv"
echo "\"id\",\"Legislation Title\",\"url\"" > $LOG
mkdir -p $OutputRootDir

CurrentLegislationYearSTART=1998
CurrentLegislationYearEND=1998
CurrentLegislationVolumeSTART=1
CurrentLegislationVolumeEND=3

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
      LegislationTitle=$(echo $LegislationTitleFull | tr -d -c ".[:alnum:]" )

      if [ "$LegislationTitle" != "404error" ]; then
        
        echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle found"
        LegislationOutputDir="$OutputRootDir/$LegislationType/$LegislationTitle"
      
        echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Making output directory at $LegislationOutputDir"
        mkdir -p $LegislationOutputDir/.raw
        
        echo "# $LegislationTitleFull" > $LegislationOutputDir/README.md
        echo "---" >> $LegislationOutputDir/README.md
        echo "Welcome to the [ConnectedGovernment](http://connectedgovernment.uk/help) archive of the $LegislationTitleFull." >> $LegislationOutputDir/README.md
        echo "" >> $LegislationOutputDir/README.md
        
        LegislationSection="introduction"
        echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Getting legislation $LegislationSection"
        
        python 040-act.py $LegislationType $LegislationYear $LegislationVolume 0 > $LegislationOutputDir/.raw/$LegislationSection.html 
        cat $LegislationOutputDir/.raw/$LegislationSection.html | html2text > $LegislationOutputDir/$LegislationSection.md
        
        if [ "$(cat $LegislationOutputDir/$LegislationSection.md | awk '{print $1}')" != "404" ]; then
          echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Got legislation $LegislationSection, saved at $LegislationOutputDir/$LegislationSection.md"

          echo "This legislation is:" >> $LegislationOutputDir/README.md 
          echo " " >> $LegislationOutputDir/README.md
          cat $LegislationOutputDir/$LegislationSection.md | sed '/^#/d' | sed '${/]/d;}' | sed '1{/]/d;}' | sed 's/^/>/' >> $LegislationOutputDir/README.md
          echo " ">> $LegislationOutputDir/README.md   
          echo "The legislation has been collated into the files bellow:" >> $LegislationOutputDir/README.md
          echo " " >> $LegislationOutputDir/README.md

          echo " * [Legislation $LegislationSection]($LegislationSection.md)" >> $LegislationOutputDir/README.md
        else
          echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: No legislation $LegislationSection, cleaning up repo"
          rm -f $LegislationOutputDir/$LegislationSection.md
        fi
        
        
        LegislationSection="body"
        echo "ConnectecdGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Getting legislation $LegislationSection"
        
        python 040-act.py $LegislationType $LegislationYear $LegislationVolume 1 > $LegislationOutputDir/.raw/$LegislationSection.html 
        cat $LegislationOutputDir/.raw/$LegislationSection.html | sed 's/\(.*\)./\1/' | sed 's/.\(.*\)/\1/' | tr -cd '\11\12\40-\176' | sed 's/></> </' | html2text -e | sed 's/^[0-9]./ &  /' | sed 's/^ \([0-9].*\)[ \t](\([0-9]*\))/ \1 \n\2. /' | sed 's/^(\([0-9]*\))/  \1. /' | sed 's/^(\([a-z]*\))/   0. \1. /' | sed 's/\([#]\) \([0-9]\+\)/\1 \2 /' | sed 's/E+W+S+N.I.$/ *&*/' > $LegislationOutputDir/$LegislationSection.md
        
        if [ "$(cat $LegislationOutputDir/$LegislationSection.md | awk '{print $1}')" != "404" ]; then
          echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Got legislation $LegislationSection, saved at $LegislationOutputDir/$LegislationSection.md"
          echo " * [Legislation $LegislationSection]($LegislationSection.md)" >> $LegislationOutputDir/README.md
        else
          echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: No legislation $LegislationSection, cleaning up repo"
          rm -f $LegislationOutputDir/$LegislationSection.md
        fi
        
        LegislationSection="schedules"
        echo "ConnectedGovernment: $Current_legislation_type_name_safe: $LegislationTitle: Getting legislation $LegislationSection"
        
        python 040-act.py $LegislationType $LegislationYear $LegislationVolume 2 > $LegislationOutputDir/.raw/$LegislationSection.html 
        cat $LegislationOutputDir/.raw/$LegislationSection.html | html2text > $LegislationOutputDir/$LegislationSection.md
        
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
        
        echo "ConnectedGovernment: Adding repo to log"
        
        echo "\"$Current_legislation_id\"","\"$LegislationTitleFull\",\"http://connectedgovernment.uk:10022/$Current_legislation_type_name_safe/$( echo $LegislationTitle | tr '[:upper:]' '[:lower:]')\"" >> $LOG
        
        echo "ConnectedGovernment: Removing $LegislationTitleFull repo from this legislation-to-md uploader host"
        rm -rf $LegislationOutputDir
        
        echo "ConnectedGovernment: Sucessfully created the $LegislationTitleFull repo"
        
      else
        echo "ConnectedGovernment: $Current_legislation_type_name_safe: No legislation found"
      fi
      
      sleep 1s
      
    done
  
  sleep 1s
  
  done

sleep 1s

done

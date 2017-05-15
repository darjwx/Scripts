#!/bin/bash

mainMenu (){

	while :
	do
		echo -e "${BBlue}1. Repo sync"
		echo -e "2. Compile"
		echo -e "3. Profiles"
		echo -e "4. ${BRed}Exit${NC}"

	    read -r -p "Choose an option: " option

	    case "$option" in
		    "1") repoSync
            ;;
            "2") compile
            ;;
            "3") profilesControl
            ;;
            "4") exit

        esac

        clear

    done

}

repoSync (){

	read -r -p "Repo sync (y/n): " repoSync

    if [ "$repoSync" = "y" ]; then

	    repo sync --force-sync

    else

	    echo -e "${Yellow}Repo syncing aborted${NC}"

	    sleep 1

    fi

}

compile (){

    source build/envsetup.sh

    read -r -p "Device to build for?: " device

    read -r -p "CARBON_BUILDTYPE=" crtype

    export CARBON_BUILDTYPE=$crtype

    read -r -p "BUILD_VARIANT=" variant

    read -r -p "Clean build? (y/n): " clean

    echo -e "${Yellow}Build type: $crtype"
    echo -e "Build variant: $variant"
    echo -e "Clean build: $clean"
    echo -e "Building for $device${NC}"

    sleep 5

    lunch carbon_$device-$variant

    if [ "$clean" = "y" ]; then

    	make clean

    fi

    make carbon -j8

}

profilesControl (){

	profilesIntegrity

	echo -e "${BBlue}1. $NAME${NC}"

	read -r -p "Choose a profile: " option

	if [ "$option" = "1" ]; then

		profile1

	fi

}

profile1 (){

	source build/envsetup.sh

	export CARBON_BUILDTYPE=$BUILDTYPE
    
    echo -e "${Yellow}$NAME"
	echo -e "Build type: $BUILDTYPE"
    echo -e "Build variant: $VARIANT"
    echo -e "Building for $DEVICE${NC}"

    sleep 5

    lunch carbon_$DEVICE-$VARIANT

    if [ "$CLEAN" = "y" ]; then

    	make clean

    fi

	make carbon -j8
}

profilesIntegrity (){

    if egrep -q -v '^#|^[^ ]*=[^;]*' "$profiles"; then

      echo -e "Profiles file contain code that was not intended to be there. Cleaning"

      # Copy the filtered profiles to a new file
      egrep '^#|^[^ ]*=[^;&]*'  "$profiles" > "$profilesSecured"
      
      profiles="$profilesSecured"

    fi

    source "$profiles"

}

# Colors
Yellow='\033[0;33m'
BRed='\033[1;31m'                 
BBlue='\033[1;34m'

# No Color
NC='\033[0m' 

# Profiles config file
profiles='profiles.cfg'
profilesSecured='profilesSecured.cfg'

mainMenu
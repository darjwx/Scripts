#!/bin/bash

function mainMenu() {

	while :
	do
		echo -e "${BBlue}1. Repo sync";
		echo    "2. Compile";
		echo    "3. Profiles";
		echo -e "4. ${BRed}Exit${NC}";

	    read -r -p "Choose an option: " option;

	    case ${option} in
		    1) repoSync;
            ;;
            2) compile;
            ;;
            3) profilesControl;
            ;;
            4) exit;
            ;;

        esac;
        clear;
    done;

}

function repoSync() {

	read -r -p "Repo sync (y/n): " repoSync;

    if [ "$repoSync" == 'y' ]; then

	    repo sync --force-sync;

    else

	    echo -e "${Yellow}Repo syncing aborted${NC}";

	    sleep 1;

    fi;

}

function compile() {

    source build/envsetup.sh;

    read -r -p "Device to build for?: " device;
    read -r -p "CARBON_BUILDTYPE=" crtype;

    export CARBON_BUILDTYPE="$crtype";

    read -r -p "BUILD_VARIANT=" variant;
    read -r -p "How many threads do you want to build?: " threads;
    read -r -p "Clean build? (y/n): " clean;

    echo -e "${Yellow}Build type: $crtype";
    echo    "Build variant: $variant";
    echo    "Threads: $threads";
    echo    "Clean build: $clean";
    echo -e "Building for $device${NC}";

    sleep 5;

    lunch carbon_"$device"-"$variant";

    if [ "$clean" == 'y' ]; then

    	make clean;

    fi;

    make carbon -j"$threads";

}

function profilesControl() {

    profilesIntegrity;

    for (( i=0; i<"$PROFILES"; ++i ))
    do

        echo -e "${BBlue}$i. ${NAME[$i]}${NC}";

    done;

    read -r -p "Choose a profile: " option;

    for (( i=0; i<"$PROFILES"; ++i ))
    do

        if [ "$option" == "$i" ]; then

            source build/envsetup.sh;
            export CARBON_BUILDTYPE="${BUILDTYPE[$i]}";
    
            echo -e "${Yellow}${NAME[$i]}";
            echo    "Build type: ${BUILDTYPE[$i]}";
            echo    "Build variant: ${VARIANT[$i]}";
            echo    "Threads: ${THREADS[$i]}";
            echo    "Clean build: ${CLEAN[$i]}";
            echo -e "Building for ${DEVICE[$i]}${NC}";

            sleep 5;

            lunch carbon_"${DEVICE[$i]}"-"${VARIANT[$i]}";

            if [ "${CLEAN[$i]}" = 'y' ]; then
                make clean;
            fi;

            make carbon -j"${THREADS[$i]}";

        fi;
    done;

}

function profilesIntegrity() {

    if grep -E -q -v '^#|^[^ *=[^;]*' "$profiles"; then
      echo "Profiles file contain code that was not intended to be there. Cleaning";
      # Copy the filtered profiles to a new file
      grep -E '^#|^[^ ]*=[^;&]*'  "$profiles" > "$profilesSecured";      
      profiles="$profilesSecured";
    fi;

    source "$profiles";

}

# Colors
Yellow='\033[0;33m';
BRed='\033[1;31m';               
BBlue='\033[1;34m';

# No Color
NC='\033[0m';

# Profiles config file
profiles='profiles.cfg';
profilesSecured='profilesSecured.cfg';

mainMenu;
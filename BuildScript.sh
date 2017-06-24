#!/bin/bash
#
# Copyright (C) 2017, Dario Jimenez "darjwx" <darjwx@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

function mainMenu() {

	while :
	do
        notesControl;

		echo -e "${BBlue}1. Repo sync";
		echo    "2. Compile";
		echo    "3. Profiles";
        echo    "4. Repopick";
		echo -e "5. ${BRed}Exit${NC}";

	    read -r -p "Choose an option: " option;

        case ${option} in
            1) repoSync;
            ;;
            2) compile;
            ;;
            3) profilesControl;
            ;;
            4) repopickControl;
            ;;
            5) exit;
            ;;

        esac;
        clear;
    done;

}

function notesControl() {

    settingsIntegrity;

    for (( i=0; i<"$NOTES"; ++i ))
    do

        case "${LEVEL[$i]}" in
            1) echo -e "${BGreen}*** \n${TEXT[$i]}";
               echo    "${LINK[$i]}";
               echo -e "${DATE[$i]}\n---";
            ;;
            2) echo -e "${BYellow}*** \n${TEXT[$i]}";
               echo    "${LINK[$i]}";
               echo -e "${DATE[$i]}\n---";
            ;;
            3) echo -e "${BRed}*** \n${TEXT[$i]}";
               echo    "${LINK[$i]}";
               echo -e "${DATE[$i]}\n--- ${NC}";
            ;;
        esac;

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

    settingsIntegrity;

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

function settingsIntegrity() {

    if grep -E -q -v '^#|^[^ *=[^;]*' "$settings"; then
      echo "Settings file contain code that was not intended to be there. Cleaning";
      # Copy the filtered settings to a new file
      grep -E '^#|^[^ ]*=[^;&]*'  "$settings" > "$settingsSecured";      
      settings="$settingsSecured";
    fi;

    source "$settings";

}

function repopickControl() {

    source build/envsetup.sh
    read -r -p "What do you want to pick? (topic/commit)" pick;

    if [ "${pick}" = "topic" ]; then
        read -r -p "Topic name: " topic;
        repopick -t "${topic}";
    fi;
    if [ "${pick}" = "commit" ]; then
        read -r -p "Commit number: " commit;
        repopick "${commit}";
    fi;
}

# Colors
Yellow='\033[0;33m';
BYellow='\033[1;33m'
BRed='\033[1;31m';               
BBlue='\033[1;34m';
BGreen='\033[1;32m'

# No Color
NC='\033[0m';

# Settings config file
settings='settings.cfg';
settingsSecured='settingsSecured.cfg';

mainMenu;
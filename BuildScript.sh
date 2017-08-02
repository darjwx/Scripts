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

function asciiTitle(){

    echo -e "${BPurple}HHHHHHHHH     HHHHHHHHH     ${BCyan}QQQQQQQQQ      ";
    echo -e "${BPurple}H${BWhite}:::::::${BPurple}H     H${BWhite}:::::::${BPurple}H   ${BCyan}QQ${BWhite}:::::::::${BCyan}QQ    ";
    echo -e "${BPurple}H${BWhite}:::::::${BPurple}H     H${BWhite}:::::::${BPurple}H ${BCyan}QQ${BWhite}:::::::::::::${BCyan}QQ  ";
    echo -e "${BPurple}HH${BWhite}::::::${BPurple}H     H${BWhite}::::::${BPurple}HH${BCyan}Q${BWhite}:::::::${BCyan}QQQ${BWhite}:::::::${BCyan}Q ";
    echo -e "  ${BPurple}H${BWhite}:::::${BPurple}H     H${BWhite}:::::${BPurple}H  ${BCyan}Q${BWhite}::::::${BCyan}O   Q${BWhite}::::::${BCyan}Q ";
    echo -e "  ${BPurple}H${BWhite}:::::${BPurple}H     H${BWhite}:::::${BPurple}H  ${BCyan}Q${BWhite}:::::${BCyan}O     Q${BWhite}:::::${BCyan}Q ";
    echo -e "  ${BPurple}H${BWhite}::::::${BPurple}HHHHH${BWhite}::::::${BPurple}H  ${BCyan}Q${BWhite}:::::${BCyan}O     Q${BWhite}:::::${BCyan}Q ";
    echo -e "  ${BPurple}H${BWhite}:::::::::::::::::${BPurple}H  ${BCyan}Q${BWhite}:::::${BCyan}O     Q${BWhite}:::::${BCyan}Q ";
    echo -e "  ${BPurple}H${BWhite}:::::::::::::::::${BPurple}H  ${BCyan}Q${BWhite}:::::${BCyan}O     Q${BWhite}:::::${BCyan}Q ";
    echo -e "  ${BPurple}H${BWhite}::::::${BPurple}HHHHH${BWhite}::::::${BPurple}H  ${BCyan}Q${BWhite}:::::${BCyan}O     Q${BWhite}:::::${BCyan}Q ";
    echo -e "  ${BPurple}H${BWhite}:::::${BPurple}H     H${BWhite}:::::${BPurple}H  ${BCyan}Q${BWhite}:::::${BCyan}O  QQQQ${BWhite}:::::${BCyan}Q ";
    echo -e "  ${BPurple}H${BWhite}:::::${BPurple}H     H${BWhite}:::::${BPurple}H  ${BCyan}Q${BWhite}::::::${BCyan}O Q${BWhite}::::::::${BCyan}Q ";
    echo -e "${BPurple}HH${BWhite}::::::${BPurple}H     H${BWhite}::::::${BPurple}HH${BCyan}Q${BWhite}:::::::${BCyan}QQ${BWhite}::::::::${BCyan}Q ";
    echo -e "${BPurple}H${BWhite}:::::::${BPurple}H     H${BWhite}:::::::${BPurple}H ${BCyan}QQ${BWhite}::::::::::::::${BCyan}Q  ";
    echo -e "${BPurple}H${BWhite}:::::::${BPurple}H     H${BWhite}:::::::${BPurple}H   ${BCyan}QQ${BWhite}:::::::::::${BCyan}Q   ";
    echo -e "${BPurple}HHHHHHHHH     HHHHHHHHH     ${BCyan}QQQQQQQQ${BWhite}::::${BCyan}QQ ";
    echo -e "                                    ${BCyan}Q${BWhite}:::::${BCyan}Q";
    echo -e "                                     ${BCyan}QQQQQQ${NC}";

}


# Main menu. Handles all the options.
function mainMenu() {

    clear;

    while :
    do
        asciiTitle;
        notesControl;

        echo -e "${BPurple}\n\n1. ${BCyan}Repo sync";
        echo -e "${BPurple}2. ${BCyan}Compile";
        echo -e "${BPurple}3. ${BCyan}Profiles";
        echo -e "${BPurple}4. ${BCyan}Repopick";
        echo -e "${BPurple}5. ${BCyan}Uploader";
        echo -e "${BWhite}<. Exit${NC}";

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
            5) uploadHandler;
            ;;
            '<') exit;
            ;;

        esac;
    clear;
    done;

}

# Handles how notes work. 
# Prints them on the console getting the values from settings.cfg.
function notesControl() {

    settingsIntegrity;

    echo -e "${UWhite}NOTES${NC}";

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

# Sync the source. 
# Check added to be sure you really want to sync. 
# You can loose unmerged/unpushed work otherwise.
function repoSync() {

    read -r -p "Repo sync (y/n): " repoSync;

    if [ "$repoSync" == 'y' ]; then

        repo sync --force-sync;

    else

        echo -e "${BPurple}Repo syncing aborted${NC}";

        sleep 1;

    fi;

}

# Handles the compile option.
# You can manually choose all the avavilable variables:
# device, build type, build variant, threads and clean build.
function compile() {

    clear;

    source build/envsetup.sh;

    read -r -p "Device to build for?: " device;
    read -r -p "CARBON_BUILDTYPE=" crtype;

    export CARBON_BUILDTYPE="$crtype";

    read -r -p "BUILD_VARIANT=" variant;
    read -r -p "How many threads do you want to build?: " threads;
    read -r -p "Clean build? (y/n): " clean;

    echo -e "${BPurple}Build type: $crtype";
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

# Handles the profile option.
# Read the values from settings.cfg, and lists the available profiles.
# Executes the desired profile.
function profilesControl() {

    clear;

    settingsIntegrity;

    for (( i=0; i<"$PROFILES"; ++i ))
    do

        echo -e "${BPurple}$i. ${BCyan}${NAME[$i]}${NC}";

    done;

    echo -e "${BWhite}<. Return${NC}"

    read -r -p "Choose a profile: " option;

    if [ "$option" == '<' ]; then

        mainMenu;

    fi;

    for (( i=0; i<"$PROFILES"; ++i ))
    do

        if [ "$option" == "$i" ]; then

            source build/envsetup.sh;
            export CARBON_BUILDTYPE="${BUILDTYPE[$i]}";
    
            echo -e "${BPurple}${NAME[$i]}";
            echo    "Build type: ${BUILDTYPE[$i]}";
            echo    "Build variant: ${VARIANT[$i]}";
            echo    "Threads: ${THREADS[$i]}";
            echo    "Clean build: ${CLEAN[$i]}";
            echo -e "Building for ${DEVICE[$i]}${NC}";

            sleep 5;

            lunch carbon_"${DEVICE[$i]}"-"${VARIANT[$i]}";

            if [ "${CLEAN[$i]}" == 'y' ]; then
                make clean;
            fi;

            make carbon -j"${THREADS[$i]}";

            if [ "${UPLOAD[$i]}" == 'y' ]; then
                echo -e "${BPurple}Uploading the file${NC}";
                uploadHandler;
            fi;

        fi;
    done;

}

# Checks that the settings.cfg file does not contain any weird code.
# In case it does, remove that code and copy it cleaned to another file.
function settingsIntegrity() {

    if grep -E -q -v '^#|^[^ *=[^;]*' "$settings"; then
      echo "Settings file contain code that was not intended to be there. Cleaning";
      # Copy the filtered settings to a new file
      grep -E '^#|^[^ ]*=[^;&]*'  "$settings" > "$settingsSecured";      
      settings="$settingsSecured";
    fi;

    source "$settings";

}

# Handles the repopick option.
# Let's you choose between topics anc single commits.
function repopickControl() {

    clear;

    source build/envsetup.sh
    echo -e "${BCyan}What do you want to pick? (topic/commit)"
    echo -e "${BWhite}<. Return${NC}"
    read pick;

    if [ "${pick}" = "topic" ]; then
        read -r -p "Topic name: " topic;
        repopick -t "${topic}";
    elif [ "${pick}" = "commit" ]; then
        read -r -p "Commit number: " commit;
        repopick "${commit}";
    elif [ "${pick}" = '<']; then
        mainMenu;
    fi;
}

# Hanldes uploading a file using ftp.
function uploadHandler() {

    settingsIntegrity;
    locationHandler;

    case "${PROTOCOL}" in
        ftp) curl -T CARBON*.zip ftp://"${USER}":"${PASS}"@"${HOST}" <<EOF
             quit
EOF
        ;;
        sftp) sftp "${HOST}" <<EOF
              put "${FILE}"
              quit
EOF
        ;;
    esac;

    locationHandler home;
}

function locationHandler() {

    if [ "${1}" == "home" ]; then
        cd "${WORKING_DIR}";
    else
        cd "${LOCATION}"
    fi
}

# Colors
BYellow='\033[1;33m';
BRed='\033[1;31m';               
BGreen='\033[1;32m';
UWhite='\033[4;37m';
BCyan='\033[1;36m';
BPurple='\033[1;35m';
BWhite='\033[1;37m';

# No Color
NC='\033[0m';

# Settings config file
settings='settings.cfg';
settingsSecured='settingsSecured.cfg';

# Directory where the script is located
WORKING_DIR='home'

mainMenu;

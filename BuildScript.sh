#!/bin/bash

mainMenu (){

	while :
	do
		echo -e "${BBlue}1. ${BBlue}Repo sync"
		echo -e "${BBlue}2. ${BBlue}Compile"
		echo -e "${BBlue}3. ${BBlue}Userdebug personal build"
		echo -e "${BBlue}4. ${BBlue}Eng experimental build"
		echo -e "${BBlue}5. ${BRed}Exit${NC}"

	    read -r -p "Choose an option: " option

	    case "$option" in
		    "1") repoSync
            ;;
            "2") compile
            ;;
            "3") profile1
            ;;
            "4") profile2
            ;;
            "5") exit

        esac

        clear

    done


}

repoSync (){

	read -r -p "Repo sync (y/n): " repoSync

    if [ "$repoSync" = "y" ]; then

	    repo sync --force-sync

    else

	    echo -e "${Yellow}Repo syncing aborted"

	    sleep 1

    fi

}

compile (){

    source build/envsetup.sh

    read -r -p "CARBON_BUILDTYPE=" crtype

    export CARBON_BUILDTYPE=$crtype

    read -r -p "BUILD_VARIANT=" variant

    echo -e "${Yellow}Build type: $crtype"
    echo -e "Build variant: $variant"
    echo -e "Building for bacon${NC}"

    sleep 5

    lunch carbon_bacon-$variant

    make carbon -j8

}

profile1 (){

	source build/envsetup.sh

	export CARBON_BUILDTYPE=Personal

	echo -e "${Yellow}Build type: Personal"
    echo -e "Build variant: Userdebug"
    echo -e "Building for bacon${NC}"

    sleep 5

    lunch carbon_bacon-userdebug

	make carbon -j8

}

profile2 (){

	source build/envsetup.sh

	export CARBON_BUILDTYPE=Experimental

	echo -e "${Yellow}Build type: Experimental"
    echo -e "Build variant: Eng"
    echo -e "Building for bacon${NC}"

    sleep 5

	lunch carbon_bacon-eng

	make carbon -j8

}

# Colors
Yellow='\033[0;33m'
BRed='\033[1;31m'                 
BBlue='\033[1;34m'

# No Color
NC='\033[0m' 

mainMenu
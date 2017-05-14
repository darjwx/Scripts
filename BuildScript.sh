#!/bin/bash

mainMenu (){

    while :
    do
        echo "1. Repo sync"
        echo "2. Compile"
        echo "3. Userdebug personal build"
        echo "4. Eng experimental build"
        echo "5. Exit"

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

	    echo "Repo syncing aborted"

    fi

}

compile (){

    source build/envsetup.sh

    read -r -p "CARBON_BUILDTYPE=" crtype

    export CARBON_BUILDTYPE=$crtype

    read -r -p "BUILD_VARIANT=" variant

    lunch carbon_bacon-$variant

    make carbon -j8

}

profile1 (){

    source build/envsetup.sh

    export CARBON_BUILDTYPE=Personal

    lunch carbon_bacon-userdebug

    make carbon -j8

}

profile2 (){

    source build/envsetup.sh

    export CARBON_BUILDTYPE=Experimental

    lunch carbon_bacon-eng

    make carbon -j8

}

mainMenu
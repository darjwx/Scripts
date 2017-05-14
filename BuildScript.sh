mainMenu

mainMenu (){

	while :
	do
		echo "1. Repo sync"
		echo "2. Compile"
		echo "3. Exit"

	    read -r -p "Choose an option: " option

	    case "$option" in
		    "1") repoSync
            ;;
            "2") compile
            ;;
            "3") exit

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
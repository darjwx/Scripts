read -r -p "Repo sync (y/n): " repoSync

if [ "$repoSync" = "y" ]; then

	repo sync --force-sync

else

	echo "Repo syncing disabled"

fi

source build/envsetup.sh

read -r -p "CARBON_BUILDTYPE=" crtype

export CARBON_BUILDTYPE=$crtype

read -r -p "BUILD_VARIANT=" variant

lunch carbon_bacon-$variant

make carbon -j8

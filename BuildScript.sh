source build/envsetup.sh

read -r -p "CARBON_BUILDTYPE=" crtype

export CARBON_BUILDTYPE=$crtype

read -r -p "Eng/Userdebug" btype

lunch carbon_bacon-$btype

make carbon -j8

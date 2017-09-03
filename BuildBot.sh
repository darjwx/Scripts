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

# Needed for crontab
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:
export USER=

# Directory where the ROM's source is located
WORKING_DIR='';

# Rom you are building
ROM=
# Make command. Normally is bacon or the name of the rom
MAKE=
# Device to build for
DEVICE=
# Build type that will appear on the device zip name
BUILDTYPE=
# Variant you want to build: eng/userdebug/user
VARIANT=
# Number of threads you will use to build the rom
THREADS=
# Clean build? (y/n)
CLEAN=
# Do you want to upload the file? (y/n)
UPLOAD=

# Upload settings
# TODO: Do not hardcode the pass here. 
# Instead, use .ntrc file or cat it from another file.

# FTP or SFTP
# TODO: make sftp work without manually enter the pass.
PROTOCOL=""
HOST=""
USER=""
PASS=""
# Location of the file
LOCATION=""
# You can use wildcards on the file name
FILE=""

# Handles uploading a file using ftp or sftp.
# TODO: make curl work with cron.
function uploadHandler() {

    locationHandler;

    case "${PROTOCOL}" in
        ftp) ftp -n "${HOST}" <<EOF
             user "${USER}" "${PASS}"
             put "${FILE}"
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


# cd to the file directory or to the workind directory when needed
function locationHandler() {

    if [ "${1}" == "home" ]; then
        cd "${WORKING_DIR}";
    else
        cd "${LOCATION}";
    fi;
}

locationHandler home;

repo sync --force-sync;

source build/envsetup.sh;

if [ "${ROM}" == "carbon" ]; then

    export CARBON_BUILDTYPE="${BUILDTYPE}";

fi;

sleep 5;

lunch "${ROM}"_"${DEVICE}"-"${VARIANT}";

if [ "${CLEAN}" == 'y' ]; then
    make clean;
fi;

make "${MAKE}" -j"${THREADS[$i]}";

if [ "${UPLOAD}" == 'y' ]; then
    echo -e "${BPurple}Uploading the file${NC}";
    uploadHandler;
fi;

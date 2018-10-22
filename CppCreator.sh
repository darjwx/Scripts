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

function title() {
  echo -e "${BGreen}*********************************${NC}";
  echo -e "${BGreen}**********CPP files Bot**********${NC}";
  echo -e "${BGreen}*********************************${NC}";
}

#Main menu. Handles each option
function mainMenu() {
  clear;

  while :
  do
    title;

    echo -e "${BPurple}\n\n1. ${BCyan}Create a cpp file";
    echo -e "${BPurple}2. ${BCyan}Create a cpp file with his header file";
    echo -e "${BWhite}<. ${BCyan}Exit${NC}";

    read -r -p "Choose an option: " option;

    case ${option} in
      1) cppFile;
      ;;
      2) cppAndHeader;
      ;;
      '<') exit;
    esac
  clear;
  done;
}

#Creates a file with the cpp extension
function cppFile() {
  read -r -p "Name?: " name;

  #Placeholder main function and iostream library
  echo "#include <iostream>" > ${name}.cpp;
  echo "" >> ${name}.cpp;
  echo "using namespace std;" >> ${name}.cpp;
  echo "" >> ${name}.cpp;
  echo "int main() {}" >> ${name}.cpp;

  echo -e "${BWhite}done${NC}";
  sleep 1;
}

#Creates a file the cpp extension and a header file with the same name
function cppAndHeader() {
  read -r -p "Name?: " name;

  #Placeholder main function and iostream library
  echo "#include <iostream>" > ${name}.cpp;
  echo "#include \"${name}.h\"" >> ${name}.cpp;
  echo "" >> ${name}.cpp;
  echo "using namespace std;" >> ${name}.cpp;
  echo "" >> ${name}.cpp;
  echo "int main() {}" >> ${name}.cpp;

  #Ifndef-define-endif structure
  echo "#ifndef _${name^^}_H_" > ${name}.h;
  echo "#define _${name^^}_H_" >> ${name}.h;
  echo "#endif //_${name^^}_H_" >> ${name}.h;

  echo -e "${BWhite}done${NC}";
  sleep 1;
}

# No Color
NC='\033[0m';

#Colors
BWhite='\033[1;37m';
BCyan='\033[1;36m';
BPurple='\033[1;35m';
BGreen='\033[1;32m';

mainMenu;

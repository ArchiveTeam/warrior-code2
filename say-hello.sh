#!/bin/bash

BG="\033[0;30;40m"
FG="\033[0;37;44m"

echo -ne "${BG}"
clear

echo
echo
echo
echo -e "      ${FG}                                                  ${BG}"
echo -e "      ${FG}  Welcome to the ArchiveTeam Warrior.             ${BG}"
echo -e "      ${FG}__________________________________________________${BG}"
echo -e "      ${FG}                                                  ${BG}"
echo -e "      ${FG}  Configure your warrior via the web interface.   ${BG}"
echo -e "      ${FG}  Point your web browser to                       ${BG}"
echo -e "      ${FG}                                                  ${BG}"
echo -e "      ${FG}    http://localhost:8001/                        ${BG}"
echo -e "      ${FG}                                                  ${BG}"

stty -echo

echo -ne "\033[0;00;00m"


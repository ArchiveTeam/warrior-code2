#!/bin/bash

tput civis
stty -echo

sudo sh -c "cat at-splash-640x400-32.fb > /dev/fb0"


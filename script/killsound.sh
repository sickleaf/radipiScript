#!/bin/bash

sig=$1

killall --signal ${sig} -q  mplayer mpg321 mpv vlc playLocalfile.sh playradiko.sh rtl_fm

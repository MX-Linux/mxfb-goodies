#!/bin/bash
### Recent files window- by PPC, 13/1/2020, for use with antiX and MX-fluxbox
### Modified by MX Linux Devs 09/12/2020
#GPL licence- do what you want with this, but please keep lines about the author, date and licence
# works on any system with yad and xdg-open installed, optionally: exo-open (see exceptions to the general rule, when launching files, near the end.
# https://github.com/jerry3904/mxfb-goodies/blob/master/recent_files.sh
============
#Parse the file that stores the recent used files, send output to recent0.txt
awk -F"file://|\" " '/file:\/\// {print $2}' ~/.local/share/recently-used.xbel > ~/.recent0.txt
#reverse order, so last file comes first, etc
tac ~/.recent0.txt > ~/.recent.txt
#function to decode file name (from %20 instead of spaces, etc, from https://unix.stackexchange.com/questions/159253/decoding-url-encoding-percent-encoding
urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}
# select file to execute
EXEC=$(yad --title="Recent files" --window-icon=/usr/share/icons/mxflux.png --width=400 --height=400 --center --separator=" " --button=gtk-cancel \
--list  --column="--> CLICK HERE TO SORT BY PATH
----------" < ~/.recent.txt)
#do decoding on file name, just in case
decoded=$(urldecode $EXEC)
# generally open with general aplication used for the selected file type
openwith=xdg-open 
###work around th error opening files with spaces is LibreOffice Writer - check extension and  force it to open with lowriter
check=$(echo -n $EXEC | tail -c 3)
	if [ "$check" == "odt" ]; then openwith=lowriter ; fi
	if [ "$check" == ".sh" ]; then openwith=exo-open ; fi
	if [ "$check" == "top" ]; then openwith=exo-open ; fi
#add quotes to name of file, just in case the name has spaces
EXEC2="'"$decoded"'"
#to open the file
runny=$(echo $openwith $EXEC2)
eval $runny

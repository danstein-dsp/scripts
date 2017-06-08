#!/bin/bash

dialog --backtitle "Find File" --title "Choose File" --clear --fselect ~/ 30 30 2> delme.tmp 
dialog --prgbox "cat delme.tmp" 0 0



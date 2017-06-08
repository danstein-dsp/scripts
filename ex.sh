#!/bin/sh

# temporary file
TEMP=/tmp/answer$$

# set default values
EXCLUDE_PAS=1 ; EXCLUDE_SB=0 ; EXCLUDE_ADLIB=1
EXCLUDE_GUS=1 ; EXCLUDE_SBPRO=1 ; EXCLUDE_SB16=1
SBC_IRQ=5 ; SBC_DMA=1

# clean up and exit
clean_up() {
  clear
  rm -f $TEMP
  exit
}

# utility function
on_off() {
  if [ "$1" = "$2" ] ; then echo on ; else echo off ; fi
}

# write configuration data to file "local.h"
save() {
  dialog --infobox "Saving..." 3 13
  echo "/* created by configure */" >local.h
  for var in EXCLUDE_SB EXCLUDE_SBPRO EXCLUDE_SB16 \
             EXCLUDE_PAS EXCLUDE_GUS EXCLUDE_ADLIB
  do
    if [ 'eval echo \\\$${var}' = 1 ]
    then
      echo "#define $var"  >>local.h
    else
      echo "#undef  $var"  >>local.h
    fi
  done
  echo "#define SBC_IRQ $SBC_IRQ" >>local.h
  echo "#define SBC_DMA $SBC_DMA" >>local.h
}

select_irq() {
  dialog --title "IRQ Configuration" \
    --radiolist "Select IRQ channel:" 11 60 4 \
    1 "IRQ 5"  'on_off $SBC_IRQ 5' \
    2 "IRQ 7"  'on_off $SBC_IRQ 7' \
    3 "IRQ 9"  'on_off $SBC_IRQ 9' \
    4 "IRQ 10" 'on_off $SBC_IRQ 10' 2>$TEMP

  if [ "$?" != "0" ] ; then return ; fi

  choice='cat $TEMP'
  case $choice in
      1) SBC_IRQ=5;;
      2) SBC_IRQ=7;;
      3) SBC_IRQ=9;;
      4) SBC_IRQ=10;;
  esac
}
select_dma() {
  dialog --title "DMA Configuration" \
    --radiolist "Select DMA channel:" 11 60 4 \
    1 "DMA 0" 'on_off $SBC_DMA 0' \
    2 "DMA 1" 'on_off $SBC_DMA 1' \
    3 "DMA 2" 'on_off $SBC_DMA 2' \
    4 "DMA 3" 'on_off $SBC_DMA 3' \
    2>$TEMP

  if [ "$?" != "0" ] ; then return ; fi

  choice='cat $TEMP'
  case $choice in
      1) SBC_DMA=0;;
      2) SBC_DMA=1;;
      3) SBC_DMA=2;;
      4) SBC_DMA=3;;
  esac
}

view_summary() {
  echo "Enabled Cards:" >$TEMP
  if [ "$EXCLUDE_ADLIB" = "0" ] ; then
echo "Adlib" >>$TEMP ; fi
  if [ "$EXCLUDE_SB" = "0" ] ; then
echo "SoundBlaster" >>$TEMP ; fi
  if [ "$EXCLUDE_SB16" = "0" ] ; then
echo "SoundBlaster 16" >>$TEMP ; fi
  if [ "$EXCLUDE_SBPRO" = "0" ] ; then
echo "SoundBlaster/Pro" >>$TEMP ; fi
  if [ "$EXCLUDE_GUS" = "0" ] ; then
echo "GravisUltraSound" >>$TEMP ; fi
  if [ "$EXCLUDE_PAS" = "0" ] ; then
echo "ProAudioSpectrum 16" >>$TEMP ; fi
  echo "IRQ channel: $SBC_IRQ" >>$TEMP
  echo "DMA channel: $SBC_DMA" >>$TEMP

  dialog \
  --title "Configuration Summary" \
  --textbox $TEMP 13 65 2>/dev/null
}

select_cards() {
  dialog --title "Select Sound Cards" \
  --checklist "Choose one or more sound cards:" 13 60 6 \
  1 "Adlib"               'on_off $EXCLUDE_ADLIB 0' \
  2 "SoundBlaster"        'on_off $EXCLUDE_SB 0' \
  3 "SoundBlaster/Pro"    'on_off $EXCLUDE_SBPRO 0' \
  4 "SoundBlaster 16"     'on_off $EXCLUDE_SB16 0' \
  5 "GravisUltraSound"    'on_off $EXCLUDE_GUS 0' \
  6 "ProAudioSpectrum 16" 'on_off $EXCLUDE_PAS 0' 2>$TEMP

  if [ "$?" != "0" ] ; then return ; fi

  EXCLUDE_ADLIB=1 ; EXCLUDE_SB=1 ; EXCLUDE_SBPRO=1
  EXCLUDE_SB16=1 ; EXCLUDE_GUS=1 ; EXCLUDE_PAS=1
  choice='cat $TEMP'
  for card in $choice
  do
    case $card in
      \"1\") EXCLUDE_ADLIB=0;;
      \"2\") EXCLUDE_SB=0;;
      \"3\") EXCLUDE_SBPRO=0;;
      \"4\") EXCLUDE_SB16=0;;
      \"5\") EXCLUDE_GUS=0;;
      \"6\") EXCLUDE_PAS=0;;
    esac
  done
}

config_menu() {
  while true
  do
    dialog \
    --title "Edit Configuration" \
    --menu "Select a function:" 12 60 5 \
    1 "Sound cards" \
    2 "IRQ configuration" \
    3 "DMA channel" \
    4 "View current configuration" \
    5 "Return to main menu" 2>$TEMP

    choice='cat $TEMP'
    case $choice in
      1) select_cards;;
      2) select_irq;;
      3) select_dma;;
      4) view_summary;;
      5) return;;
    esac
  done
}

main_menu() {
  dialog \
    --title "Sound Driver Configuration Utility" \
    --menu "Select a function:" 10 60 3 \
    1 "Edit configuration" \
    2 "Save configuration" \
    3 "Exit" 2>$TEMP

  choice='cat $TEMP'
  case $choice in
    1) config_menu;;
    2) save;;
    3) clean_up;;
  esac
}

while true
do
  main_menu
#!/bin/sh
# Backup all files under home directory to a single # floppy
# Display message with option to cancel
dialog --title "Backup" --msgbox "Time for backup \ of home directory. \
Insert formatted 3-1/2\" floppy and press <Enter> \ to start backup or \
<Esc> to cancel." 10 50
# Return status of non-zero indicates cancel
if [ "$?" != "0" ]
then
  dialog --title "Backup" --msgbox "Backup was \ canceled at your
  request." 10 50
else
  dialog --title "Backup" --infobox "Backup in \ process..." 10 50
  cd ~
  # Backup using tar; redirect any errors to a
  # temporary file
  # For multi-disk support, you can use the
  # -M option to tar
  tar -czf /dev/fd1 . >|/tmp/ERRORS$$ 2>&1
  # zero status indicates backup was successful
  if [ "$?" = "0" ]
    then
    dialog --title "Backup" --msgbox "Backup \
completed successfully." 10 50
    # Mark script with current date and time
    touch ~/.backup
  else
    # Backup failed, display error log
    dialog --title "Backup" --msgbox "Backup failed \ -- Press
<Enter>
    to see error log." 10 50
   dialog --title "Error Log" --textbox /tmp/ERRORS$$ 22 72
  fi
fi
rm -f /tmp/ERRORS$$
clear
dialog --title 'Message' --msgbox 'Hello, world!' 5 20
dialog --title "Message"  --yesno "Are you having\ fun?" 6 25
dialog --infobox "Please wait" 10 30 ; sleep 4
dialog --inputbox "Enter your name:" 8 40 2>answer.txt
dialog --textbox /etc/profile 22 70
dialog --menu <text> <height> <width><menu-height> [<tag><item>]
dialog --menu "Choose one:" 10 30 3 1 red 2 green\ 3 blue
dialog --checklist "Choose toppings:" 10 40 3 \
        1 Cheese on \
        2 "Tomato Sauce" on \
        3 Anchovies off
dialog --backtitle "CPU Selection" \
  --radiolist "Select CPU type:" 10 40 4 \
        1 386SX off \
        2 386DX on \
        3 486SX off \
        4 486DX off


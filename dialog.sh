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


#!/bin/bash
# utilitymenu.sh - A sample shell script to display menus on screen
# Store menu options selected by the user
INPUT=/tmp/menu.sh.$$

# Storage file for displaying cal and date command output
OUTPUT=/tmp/output.sh.$$

# get text editor or fall back to vi_editor
vi_editor=${EDITOR-vi}

# Location of DSP_Build_Scripts
DSPLOC="/home/dan/git/custom_slackbuilds/dspbuilds/"

# trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

CWD=$(pwd)
TMPFILE="/tmp/dsp1.tmp"

#
# Purpose - display output using msgbox 
#  $1 -> set msgbox height
#  $2 -> set msgbox width
#  $3 -> set msgbox title
#
function display_output(){
	local h=${1-10}			# box height default 10
	local w=${2-41} 		# box width default 41
	local t=${3-Output} 	# box title 
    dialog --backtitle "Root Comand Menu" --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w} 
}

function display_text(){
    local h=${1-10}
    local w=${2-41}
    local t=${3-Output}
    dialog --backtitle "Root Command Menu" --title "${t}" --clear --textbox \
       $OUTPUT ${h} ${w}

    
}

function display_info(){
    local h=${1-10}
    local w=${2-41}
    local bt=${3-"Searching"}
    local ti=${4-"Found"}
    dialog --backtitle "${bt}" --title "${ti}" --infobox "$(<$OUTPUT)" ${h} ${w}

}
#
# Purpose - display current system date & time
#
function show_date(){
	echo "Today is $(date) @ $(hostname -f)." >$OUTPUT
    display_output 6 60 "Date and Time"
}
#
# Purpose - display a calendar
#
function show_calendar(){
	cal >$OUTPUT
	display_output 13 25 "Calendar"
    dialog --clear --calendar Today 0 0 2> $OUTPUT 
    display_text 0 0 Selected_Date
}
function raid_stat(){
    view_com "cat /proc/mdstat" "Raid Status"
}
function display_com(){
    dialog --clear --title "$1" --prgbox "$1" 30 80
}
function view_com(){
    $1 > $OUTPUT
    local h=${3-0}
    local w=${4-0}
    display_text "${h}" "${w}" "$2"
}
function free_space(){
    view_com "df -h" "Free Space"

}
function apache_stats(){
    lynx http://localhost/server-status
}
function slack_up(){
    while true
    do
        dialog --clear  --help-button --backtitle "Slackware Update" \
            --title "[U P D A T E - S Y S T E M]" \
            --menu "Choose" 0 0 0 \
            Update_GPG "Update Mirror GPG Files" \
            Update_Slackpkg "Sync Package List With Mirrors" \
            Install_New "Install New Packages" \
            Clean_System "Remove Old/Unofficial Packages" \
            Upgrade_All "Upgrade all Packages" \
            Exit "Exit To Main" 2>"${INPUT}"
        
        menuitem=$(<"${INPUT}")
        
        case $menuitem in
            Update_GPG) display_com "slackpkg update gpg";;
            Update_Slackpkg) display_com "slackpkg update";;
            Install_New) slackpkg install-new;;
            Clean_Syetem) slackpkg clean-system;;
            Upgrade_All) slackpkg upgrade-all;;
            Exit) break;;
        esac
    done
}
function ls_log(){
    view_com "ls -lh /var/log" "/var/log Directory"
}

function file_display(){
     cat $1 > $OUTPUT
    display_text 0 0 "$1"
}

function tail_display(){
    tail -100 $1 > $OUTPUT
    display_text 0 0 "Last 100 Lines of $1"
}

function pick_file(){
    dialog --backtitle "Pick File" --title "Choose File" \
        --fselect $1 20 70 2> "${INPUT}"
}

function pick_log(){
    pick_file /var/log/
    file=$(<"${INPUT}")
    file_display $file
}

function mk_dsp_list(){
    file=$DSPLOC"dspbuilds.txt"
    cd $DSPLOC
    rm $file
    touch $file
    for i in */*; do
    NAME=$(echo $i | cut -d "/" -f2)
    FILES=$(ls $i)
    echo $NAME > $OUTPUT
    display_info 4 60 
    source $i/${NAME}.info 2> junk
        SHORTDES=$(grep -m 1 $NAME $i/slack-desc | cut -d " " -f2-)
            echo NAME: $NAME >> $file
            echo LOCATION: $i >> $file
            echo FILES: $FILES >> $file
            echo VERSION: $VERSION >> $file
            echo DOWNLOAD: $DOWNLOAD >> $file
            echo DOWNLOAD_x86_64: $DOWNLOAD_x86_64 >> $file
            echo MD5SUM: $MD5SUM >> $file
            echo D5SUM_x86_64: $MD5SUM_x86_64 >> $file
            echo REQUIRES: $REQUIRES >> $file
            echo SHORT DESCRIPTION: $SHORTDES >> $file
            echo >> $file
    done
    cd $CWD

}
function mk_dsp_sh_list(){
    file=$DSPLOC"dspshtlst.txt"
    cd $DSPLOC
    rm $file
    touch $file
    for i in */*; do
        NAME=$(echo $i | cut -d "/" -f2)
        echo $NAME > $OUTPUT
        display_info 4 60
        source $i/${NAME}.info 2>junk
            echo $NAME >> $file
    done
    sort $file > $OUTPUT
    cat $OUTPUT > $file
    cd $CWD
}
function log_rotate(){
   
    display_com "logrotate -v --force /etc/logrotate.conf"
    
}
function fire_menu(){
    while true
    do
        dialog --clear --backtitle "FireWall Menu" \
            --title "[ F I R E W A L L ]" \
            --menu "Choose Action" 0 0 0 \
            Edit_FireWall "Edit rc.firewall file" \
            Extract_IP "Genreate a New List Of Bad IP's" \
            New_Blocked "List IP's The Need to be added" \
            Merge_List "Merge New and Old List" \
            All_Blocked "List All IP's to be Blocked" \
            Who_List "Generate WhoIS List of Blocked IP's" \
            Check_Blocked "Check Message Log for Bad IP's" \
            Restart_Firewall "Restart Firewall:" \
            Exit "Exit Menu" 2>"${INPUT}"
        
        menuitem=$(<"${INPUT}")
        
        case $menuitem in
            Edit_FireWall) vim /etc/rc.d/rc.firewall;;
            Extract_IP) display_com ~/badlst.sh;;
            Merge_List) ~/mergnsrt.sh;;
            New_Blocked) file_display ~/badip.lst;;
            All_Blocked) file_display ~/badip.lst.new;;
            Who_List) display_com ~/wholist.sh;;
            Check_Blocked) display_com ~/ipmsg.sh;;
            Restart_Firewall) display_com /etc/rc.d/rc.firewall;;
            Exit) break;;
        esac
    done
}

function main_menu(){
while true
do

    dialog --clear --backtitle "Linux Root Menu" \
    --title "[ M A I N - M E N U ]" \
    --menu "You can use the UP/DOWN arrow keys, the first \n\
    letter of the choice as a hot key, or the \n\
    number keys 1-9 to choose an option.\n\
    Choose the TASK" 0 0 0 \
    Calendar "Displays a calendar" \
    Editor "Lauch Default File Editor" \
    Update_Menu "Slackpkg Functions" \
    Log_Menu "System Logs Menu" \
    System_Stat_Menu "Various System Sats" \
    FireWall "Fire Wall Utilities" \
    DSP_PKG "DSP Package Menu" \
    Exit "Exit to the shell" 2>"${INPUT}"

    menuitem=$(<"${INPUT}")

    case $menuitem in
	    Calendar) show_calendar;;
	    Editor) $vi_editor;;
        Update_Menu) slack_up;;
        Log_Menu) log_menu;;
        System_Stat_Menu) sys_menu;;
        FireWall) fire_menu;;
        DSP_PKG) dsp_menu;;
	    Exit) echo "Bye"; break;;
    esac

done
}
function sys_menu(){
while true
do
    dialog --clear --backtitle "System Stats" \
        --title "[ S Y S T E M - S T A T U S ]" \
        --menu "Choose Task" 0 0 0 \
        Raid_Status "Display System Raid Stats" \
        Date_Time "Date & Time" \
        Free_Space "File System Free Space" \
        Apache_Status "Webserver Stats" \
        List_Drives "List Drives" \
        Mounts "List Mounts" \
        Exit "Exit to Main" 2>"${INPUT}"
        menuitem=$(<"${INPUT}")

        case $menuitem in 
            Raid_Status) raid_stat;;
            Date_Time) show_date;;
            Free_Space) free_space;;
            Apache_Status) apache_stats;;
            List_Drives) view_com "fdisk -l" "Drive List";;
            Mounts) view_com "mount" "Mount Points";;
            Exit) break;;
        esac

done
}

function log_menu(){
while true
do

    dialog --clear --backtitle "Linux Root Menu" \
    --title "[ L O G - M E N U ]" \
    --menu "Choose the TASK" 0 0 0 \
    Display_Log_Directory "Displays Log Directory" \
    Display_Syslog "Displays Syslog" \
    Display_Tail_Syslog "Displays Last 200 Lines of Syslog" \
    Pick_Log_To_Display "Pick log file to Display" \
    Rotate_Logs "Forece Rotate Log files" \
    Exit "Exit to Main Menu" 2>"${INPUT}"

    menuitem=$(<"${INPUT}")
    case $menuitem in
	    Display_Log_Directory) ls_log;;
	    Display_Syslog) file_display /var/log/syslog;;
        Display_Tail_Syslog) tail_display /var/log/syslog;;
        Pick_Log_To_Display) pick_log;;
        Rotate_Logs) log_rotate;;
        Exit) break;;
    esac
done
}

function dsp_menu(){
    while true
    do  
        dialog --clear --backtitle "DSP Package Menu" \
            --title "[D S P - M E N U]" \
            --menu "Options:" 0 0 0 \
            Pkg_List "List Packages" \
            Pkg_Short "List Package Names" \
            Make_List "Make dspbuilds.txt" \
            Make_Name_List "Make dspshtlst.txt" \
            Show_Build_List "Show Build List" \
            Exit "Exit Menu" 2>"${INPUT}"
    
        menuitem=$(<"${INPUT}")
        case $menuitem in
            Pkg_List) file_display $DSPLOC"dspbuilds.txt";;
            Pkg_Short) file_display $DSPLOC"dspshtlst.txt";;
            Make_List) mk_dsp_list;;
            Make_Name_List) mk_dsp_sh_list;;
            Show_Build_List) show_build;;
            Exit) break;;
        esac
    done
}

function show_build (){
    list=$DSPLOC"dspshtlst.txt"
    rm $OUTPUT
    touch $OUTPUT
    while IFS= read -r line
    do  
        printf "%s \" \" " $line >> $OUTPUT
    done < $list
    dialog --menu "Pick One" 0 0 0 \
        --file $OUTPUT 2>"${INPUT}"
    dsp_build_list "$(<"${INPUT}")"
}
function dsp_build_list(){

#make list of req to build pkg
    cd $DSPLOC
    ./buildlst.sh $1 > $OUTPUT
    ./makeodr.sh $OUTPUT > $TMPFILE
    view_com "./rmvdup.sh $TMPFILE " "$1's Build List" 30 60
    #display_text 30 60 "Build list for $1"
    cd $CWD
}
function crap(){

name=$1
    rm $OUTPUT
    touch $OUTPUT
    FILEIN=$DSPLOC'dspbuilds.txt'
    build_list name
    echo $name >> $OUTPUT

    function build_list(){
        FILEIN=$DSPLOC"dspbuilds.txt"
        NAME=$1
        grep -A 9 'NAME: '$1 $FILEIN | cut -d " " -f2- > $TMPFILE
            exec < $TMPFILE
                read  NAME  
                read  LOCATION
                read  FILES
                read  VERSION
                read  DOWNLOAD
                read  DOWNLOAD_x86_64
                read  MD5SUM
                read  MD5SUM_x86_64
                read  REQUIRES
                read  SHORT
            rm $TMPFILE
        REQTMP=$NAME'.bl'
        if  [ "$REQUIRES" != "REQUIRES:" ] 
            then
                echo $REQUIRES | awk ' {printf"%i\n",NF
                                    for (i=1; i<=NF; i++) 
                                    printf"%s\n",$i}
                                    '>$REQTMP
        fi
    }   
    
    echo $NAME >> $OUTPUT
    if [ -e $REQTMP ]
        then
            exec < $REQTMP
            read NUMDEPS
            for ((i=0 ;i< NUMDEPS;i++))
                do
                read DEP
                crap $DEP
            done
            rm $REQTMP
    fi
    
}
#***MAIN*****

main_menu

# if temp files found, delete em
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT

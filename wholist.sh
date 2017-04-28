INPUT1="badip.lst.new"
TMP1="temp.tmp"
TMP2="temp2.tmp"
FNAME="notblocked.lst"
BADCOUNT="0"
echo Grab IP list from badip.lst.new
cut -d" " -f7 $INPUT1 > $TMP1
echo Get Whois List
rm $TMP2
input=$TMP1
while IFS= read line
    do
        echo $line >> $TMP2
        BADCOUNT=$[BADCOUNT +1]
        printf "Looking at IP # %s\r" "$BADCOUNT"
        whois $line |grep -e person: -e email: -e address: -e irt: >> $TMP2 
    done < $input 

echo Reformat echo list
cat $TMP2 > badpeople.lst
echo Total Bad IPs = "$BADCOUNT"
rm $TMP1
rm $TMP2
cat badpeople.lst
#echo Grab Failed Attemps
#cat $INPUT1 | grep Failed >$TMP1
#echo Sort and remove Dups
#sort -u -t" " -k13n,13 $TMP1 > $TMP2
#echo Extract IP Address
#cut -d" " -f13 $TMP2 > $TMP1
#input=$TMP1
#while IFS= read line
#do
#        echo "$line"  *From Messages >> $TMP2
#done < "$input"
#cut -d" " -f7 badip.lst.new > $TMP1
#echo merge 
#cat $TMP2 >> $TMP1
#echo Sort Merge
#sort -u -n $TMP1 > $TMP2
#echo $(date) >> $FNAME
#cat $TMP2 | grep *From >> $FNAME
#echo Cleanup
#rm $TMP1
#rm $TMP2
#mv $INPUT1 /var/log/messages.old
#touch $INPUT1
#echo IPs Not Blocked List
#cat $FNAME
#NAME="badip.lst"
#NAME2="badip.lst.old"
#NAME3="badip.lst.new"
#TMP="temp.lst"
#rm $NAME2
#mv $NAME3 $NAME2
#cat $NAME $NAME2 > $TMP
#sort -ut" " -k7n,7 $TMP > $NAME3
#rm $TMP
## Gets list of unique ip adresses
#NAME='failed.login'
#MANAME='count.lst'
#TMP1='ip.tmp'
#TMP2='ip2.tmp'
#OUTFILE='badip.lst'
#echo Getting List
#lastb > $NAME
#cut -c 23-37 $NAME > $TMP1
##cat $TMP1 >> $MANAME
#echo Adding to Count List
#input=$TMP1
#while IFS= read line
#do
#    echo "$line"'  '$(date) >> $MANAME
#done < "$input"
#sort -n $MANAME > $TMP2
#cat $TMP2 > $MANAME
#echo Sorting List
#rm $TMP2
#sort -nu $TMP1 > $TMP2
#echo Removing Oldlist
#rm $OUTFILE
#echo Formating List
#input=$TMP2
#while IFS= read line
#do
#    echo '$IPT -A INPUT -p ALL -s '"$line"' -j DROP' >> $OUTFILE
#done < "$input"
#echo Cleaning Up
#rm $TMP1
#rm $TMP2
#cat /dev/null > /var/log/btmp
##cat $OUTFILE
echo Done

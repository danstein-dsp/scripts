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
echo Total Bad IPs = "$BADCOUNT"
echo Done

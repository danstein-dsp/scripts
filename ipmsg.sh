INPUT1="/var/log/messages"
TMP1="temp.tmp"
TMP2="temp2.tmp"
FNAME="notblocked.lst"
echo Grab Failed Attemps
cat $INPUT1 | grep Failed >$TMP1
echo Sort and remove Dups
sort -u -t" " -k13n,13 $TMP1 > $TMP2
echo Extract IP Address
cut -d" " -f13 $TMP2 > $TMP1
input=$TMP1
while IFS= read line
do
        echo "$line"  *From Messages >> $TMP2
done < "$input"
cut -d" " -f7 badip.lst.new > $TMP1
echo merge 
cat $TMP2 >> $TMP1
echo Sort Merge
sort -u -n $TMP1 > $TMP2
echo $(date) >> $FNAME
cat $TMP2 | grep *From >> $FNAME
echo Cleanup
rm $TMP1
rm $TMP2
mv $INPUT1 /var/log/messages.old
touch $INPUT1
echo IPs Not Blocked List
cat $FNAME

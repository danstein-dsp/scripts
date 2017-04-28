# Gets list of unique ip adresses
NAME='failed.login'
MANAME='count.lst'
TMP1='ip.tmp'
TMP2='ip2.tmp'
OUTFILE='badip.lst'
echo Getting List
lastb > $NAME
cut -c 23-37 $NAME > $TMP1
#cat $TMP1 >> $MANAME
echo Adding to Count List
input=$TMP1
while IFS= read line
do
    echo "$line"'  '$(date) >> $MANAME
done < "$input"
sort -n $MANAME > $TMP2
cat $TMP2 > $MANAME
echo Sorting List
rm $TMP2
sort -nu $TMP1 > $TMP2
echo Removing Oldlist
rm $OUTFILE
echo Formating List
input=$TMP2
while IFS= read line
do
    echo '$IPT -A INPUT -p ALL -s '"$line"' -j DROP' >> $OUTFILE
done < "$input"
echo Cleaning Up
rm $TMP1
rm $TMP2
cat /dev/null > /var/log/btmp
#cat $OUTFILE
echo Done

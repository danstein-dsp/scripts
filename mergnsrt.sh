NAME="badip.lst"
NAME2="badip.lst.old"
NAME3="badip.lst.new"
TMP="temp.lst"
rm $NAME2
mv $NAME3 $NAME2
cat $NAME $NAME2 > $TMP
sort -ut" " -k7n,7 $TMP > $NAME3
rm $TMP

CWD=($pwd)
TMPF=$CWD"/tmp.fl"
PHOTODIR="/usr/share/files/photos"
echo $CWD
cd $PHOTODIR
for i in */*; do
NAME=$(echo $i | cut -d "/" -f2)
mv $i /usr/share/files/upload/photo/ 
#echo -
#echo $i
#echo $NAME
#echo -
#exiv2 $i
#isource $i/${NAME}.info
#SHORTDES=$(grep -m 1 $NAME $i/slack-desc | cut -d " " -f2-)
#            echo NAME: $NAME
#            echo LOCATION: $i
#3            echo FILES: $FILES
#            echo VERSION: $VERSION
#            echo DOWNLOAD: $DOWNLOAD
#            echo DOWNLOAD_x86_64: $DOWNLOAD_x86_64
#            echo MD5SUM: $MD5SUM
#            echo D5SUM_x86_64: $MD5SUM_x86_64
#            echo REQUIRES: $REQUIRES
#            echo SHORT DESCRIPTION: $SHORTDES
#            echo
done
cd $CWD
rm $TMPF

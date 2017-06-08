CWD=$(pwd)
cd /home/dan/git/slackbuilds
OUTFILE="slackbuilds.txt"
rm $OUTFILE
touch $OUTFILE

for i in */*; do
   NAME=$(echo $i | cut -d "/" -f2)
   FILES=$(ls $i)
   source $i/${NAME}.info
   SHORTDES=$(grep -m 1 $NAME $i/slack-desc | cut -d " " -f2-)
   echo SLACKBUILD NAME: $NAME >> $OUTFILE
   echo SLACKBUILD LOCATION: "./"$i >> $OUTFILE
   echo SLACKBUILD FILES: $FILES >> $OUTFILE
   echo SLACKBUILD VERSION: $VERSION >> $OUTFILE
   echo SLACKBUILD DOWNLOAD: $DOWNLOAD >> $OUTFILE
   echo SLACKBUILD DOWNLOAD_x86_64: $DOWNLOAD_x86_64 >> $OUTFILE
   echo SLACKBUILD MD5SUM: $MD5SUM >> $OUTFILE
   echo SLACKBUILD MD5SUM_x86_64: $MD5SUM_x86_64 >> $OUTFILE
   echo SLACKBUILD REQUIRES: $REQUIRES >> $OUTFILE
   echo SLACKBUILD SHORT DESCRIPTION: $SHORTDES >> $OUTFILE
   echo >> $OUTFILE
 done
 cd $CWD

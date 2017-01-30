 in */*; do
   NAME=$(echo $i | cut -d "/" -f2)
   FILES=$(ls $i)
   source $i/${NAME}.info
   SHORTDES=$(grep -m 1 $NAME $i/slack-desc | cut -d " " -f2-)
   echo SLACKBUILD NAME: $NAME
   echo SLACKBUILD LOCATION: "./"$i
   echo SLACKBUILD FILES: $FILES
   echo SLACKBUILD VERSION: $VERSION
   echo SLACKBUILD DOWNLOAD: $DOWNLOAD
   echo SLACKBUILD DOWNLOAD_x86_64: $DOWNLOAD_x86_64
   echo SLACKBUILD MD5SUM: $MD5SUM
   echo SLACKBUILD MD5SUM_x86_64: $MD5SUM_x86_64
   echo SLACKBUILD REQUIRES: $REQUIRES
   echo SLACKBUILD SHORT DESCRIPTION: $SHORTDES
   echo
 done




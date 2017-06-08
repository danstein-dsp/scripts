CWD=($pwd)
TMPF="tmp.fl"
TMPF2="tmp.f2"
FAILDIR="/usr/share/files/upload/failed"
SOURCEDIR="/usr/share/files/upload/photo"
PHOTODIR="/usr/share/files/photos"
#echo $CWD
cd $SOURCEDIR
printf "Working"

for i in *.*; do
# NAME=$(echo $i | cut -d "/" -f2)
#echo -
#echo $i
#echo $NAME
#echo -
#    echo $i
    exiv2 $i | grep timestamp > $TMPF
    echo $(cat $TMPF | cut -s -d " " -f4) > $TMPF2
    DESTDIR1=$(cat $TMPF2 | cut -d ":" -f1)
    DESTDIR2=$(cat $TMPF2 | cut -d ":" -f2)
    if [ $DESTDIR1 = $DESTDIR2 ]
        then
        echo $i FAILED moving to $FAILDIR for review
        mv $i $FAILDIR/
    else
        echo $i Moving TO $PHOTODIR/$DESTDIR1/$DESTDIR2/
        if [ -d "$PHOTODIR/$DESTDIR1" ]
        then
#            echo 1
            if [ -d "$PHOTODIR/$DESTDIR1/$DESTDIR2" ]
            then
 #               echo 2
                if [ ! -f $PHOTODIR/$DESTDIR1/$DESTDIR2/$i ]
                then
  #                  echo 3
                    mv $i $PHOTODIR/$DESTDIR1/$DESTDIR2/
                else 
   #                 echo 4
                    mv $i $FAILDIR
                fi
            else
    #            echo 5
                mkdir $PHOTODIR/$DESTDIR1/$DESTDIR2
                mv $i $PHOTODIR/$DESTDIR1/$DESTDIR2
            fi
        else
     #       echo 6
            mkdir $PHOTODIR/$DESTDIR1
            mkdir $PHOTODIR/$DESTDIR1/$DESTDIR2
            mv $i $PHOTODIR/$DESTDIT1/$DESTDIR2
        fi
    fi
done
echo "DONE"

rm $TMPF
cd $CWD



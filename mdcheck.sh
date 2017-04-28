RAID=$1
echo check > /sys/block/md$RAID/md/sync_action
watch -n 2 cat /proc/mdstat

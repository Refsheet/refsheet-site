#!/bin/bash
#
# This will create a 2GB swapfile on our instances, allowing for this awful deploy bubble
# to not break all the things. This is run on the Beanstalk servers!

SWAPFILE=/var/swapfile
SWAP_MEGABYTES=2048

if [ -f $SWAPFILE ]; then
	echo "Swapfile $SWAPFILE found, assuming already setup"
	exit;
fi

/bin/dd if=/dev/zero of=$SWAPFILE bs=1M count=$SWAP_MEGABYTES
/bin/chmod 600 $SWAPFILE
/sbin/mkswap $SWAPFILE
/sbin/swapon $SWAPFILE

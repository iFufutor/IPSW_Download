#!/bin/bash
######
# Apple no longer provide hash of files, so the checking function is disabled for the moment
# If you don't want to enable email, please comment line 60
######
## Script created by iFufutor. Thanks to Leon Klingele for his API ##
######

MAIL_SENDER='ADDRESS_FROM'
MAIL_RECIPIENT='ADDRESS_TO'
DIRECTORY='DIRECTORY'

ERROR='ERROR : Please verify logs' # DIRECTORY/ipsw.log
ERROR1='ERROR : Please verify your network connection'
ERROR2='IPSW already downloaded...'
ERROR3='Mismatching hash. Corrupted file ?'
RESULT=''

echo -n "##########################
#  Download latest ipsw  #
##########################


"

if [[ "$(ping -c 1 8.8.8.8 | grep "100% packet loss" )" != "" ]]
then
	RESULT=$ERROR1
else
	if [[ -z $1 ]]
	then
		echo "Please enter the iDevice ID :"
		echo "ex: iPhone8,1 for an iPhone 6s"
		read hardware_id
	else
		hardware_id=$1
	fi

	url=$(curl -s https://istheapplestoredown.com/api/updates/ios/latest | grep $hardware_id | tail -1 | cut -d\" -f4)
	file=$(echo $url | cut -d / -f6)

	if [ -f $DIRECTORY/$file ]
	then
		#local_hash=$(md5sum $DIRECTORY/$file | cut -d " " -f1)
		#remote_hash=$(curl -s https://istheapplestoredown.com/api/updates/ios/latest | grep $local_hash | cut -d: -f2 | cut -d\" -f2)
		#if [ "$local_hash" == "$remote_hash" ]
		#then
			RESULT=$ERROR2
		#else
		#	RESULT=$ERROR3
		#fi
	else
		echo "Downloading..."
		cd $DIRECTORY
		curl -O $url
		#local_hash=$(md5sum $DIRECTORY/$file | cut -d " " -f1)
		#remote_hash=$(curl -s https://istheapplestoredown.com/api/updates/ios/latest | grep $local_hash | cut -d: -f2 | cut -d\" -f2)
		#if [ "$local_hash" == "$remote_hash" ]
		#then
			RESULT=$(echo $hardware_id "Success")
			echo "$(date) : New firmware downloaded for $hardware_id in $DIRECTORY/$file" | mail -s "New firmware download" -a "From: $MAIL_SENDER" $MAIL_RECIPIENT
		#else
		#	RESULT=$ERROR3
		#	rm $DIRECTORY/$file
		#fi
	fi
fi
echo $RESULT
echo $(date) : $RESULT >> $DIRECTORY/ipsw.log

## Script created by iFufutor. Thanks to Leon Klingele for his API ##
#!/bin/bash

error1='Error : Please verify your network connection'
error2='IPSW already downloaded...'
error3='Mismatching hash. Corrupted file ?'

echo -e "##########################\n#  Download latest ipsw  #\n##########################\n\n\n"

if [[ "$(ping -c 1 8.8.8.8 | grep "100% packet loss" )" != "" ]]; then
	echo $(date) : $error1 >> ipsw.log
	echo $error1
	exit 1
else
	if [[ -z $1 ]]; then
		echo -e "Please enter the iDevice ID : \nex: iPhone8,1 for an iPhone 6s\n"
		read hardware_id
	else 
		hardware_id=$1
	fi


    url=$(curl -s https://istheapplestoredown.com/api/updates/ios | grep $hardware_id | tail -1 | cut -d\" -f4)
	file=$(echo $url | cut -d / -f6)

    if [ -f $file ]; then
        local_hash=$(md5 -q $file)
        remote_hash=$(curl -s https://istheapplestoredown.com/api/updates/ios | grep $local_hash | cut -d: -f2 | cut -d\" -f2)
        if [ "$local_hash" == "$remote_hash" ]; then
            echo $(date) : $error2 >> ipsw.log
	    echo $error2
            exit 1
        else
	    echo $(date) : $error3 >> ipsw.log
	    echo $error3
        fi
		exit 1

    else
		echo "Downloading ..."
		curl -O -# $url
        local_hash=$(md5 -q $file)
        remote_hash=$(curl -s https://istheapplestoredown.com/api/updates/ios | grep $local_hash | cut -d: -f2 | cut -d\" -f2)
        if [ "$local_hash" == "$remote_hash" ]; then
            echo $(date) : $hardware_id Success ! >>ipsw.log
	    echo $hardware_id "Success !"
            exit 1
        else
	    echo $(date) : $error3 >> ipsw.log
            echo $error3
            rm $file
        fi
    fi
fi


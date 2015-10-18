## Script created by iFufutor. Thanks to Leon Klingele for his API ##
#!/bin/bash

echo -e "##########################\n#  Download latest ipsw  #\n##########################\n\n\n"

if [[ "$(ping -c 1 8.8.8.8 | grep "100% packet loss" )" != "" ]]; then
	echo "Error : Please verify your network connection"
	exit 1
else

    # hardware_id=....
    # please delete the following 'if' bloc if you specify your ID in the previous command
	if [[ -z $1 ]]; then
		echo -e "Please enter the iDevice ID : \nex: iPhone7,2\n"
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
            echo -e "\nIPSW already downloaded...\n"
            exit 1
        else
            echo "Mismatching hash. Corrupted file ?"
        fi
		exit 1

    else
		echo -e "\nDownloading ..."
		curl -O -# $url
        local_hash=$(md5 -q $file)
        remote_hash=$(curl -s https://istheapplestoredown.com/api/updates/ios | grep $local_hash | cut -d: -f2 | cut -d\" -f2)
        if [ "$local_hash" == "$remote_hash" ]; then
            echo "Success !"
            exit 1
        else
            echo "Mismatching hash. Corrupted file ?"
            rm $file
        fi
	fi
fi


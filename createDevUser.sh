#!/bin/bash
#Install required packages
sudo apt-get install whois >/dev/null
userPass=$1
shaPass=`mkpasswd -m sha-512 $userPass -s 'usersalt'`
useradd -u 1099 devadmin
STATE1=$?
usermod -p $shaPass devadmin
STATE2=$?
usermod -aG sudo devadmin
STATE3=$?
if [ $STATE1 -eq 0 -a $STATE2 -eq 0 -a $STATE3 -eq 0 ]; then
    echo "SUCCESS: User  creation"
else 
    echo "FAILURE: User  creation"
    exit 1;
fi

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "0 0 */7 * * sudo gpasswd -d devadmin sudo && deluser --remove-home --force devadmin" >> mycron
#install new cron file
crontab mycron
rm mycron


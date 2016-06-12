#!/bin/bash
#

# check root privilegs
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# install dir abfragen
echo "install to:"
read installDir

# create & copy files
mkdir $installDir
cp fcf.conf.sample "$installDir/fcf.conf"
cp find-convert-flv "$installDir/"
touch $installDir/fcf.list
touch $installDir/fcf.log

# conf file env vars
FCF_CFG="$installDir/fcf.conf"
export FCF_CFG
echo "FCF_CFG=\"$installDir/fcf.conf\"" >> /etc/environment

# create symlinks
ln -s $installDir/find-convert-flv /usr/local/bin/find-convert-flv

# set permissions
chmod +x $installDir/find-convert-flv
chmod +x $installDir/fcf.conf

# write configFile
echo "scriptDir=\"$installDir\"" >> $installDir/fcf.conf
echo "scriptFileName=\"find-convert-flv\"" >> $installDir/fcf.conf
echo "listFileName=\"fcf.list\"" >> $installDir/fcf.conf
echo "logFileName=\"fcf.log\"" >> $installDir/fcf.conf
echo "deleteFileAfterConvert=\"no\"" >> $installDir/fcf.conf

# install needed packages
apt-get update && apt-get install ffmpeg --install-recommends

echo "finished..."
echo "please edit fcf.conf for further configuration"

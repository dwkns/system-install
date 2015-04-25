killall -9 Krep 
downloadFile="$HOME/Downloads/Krep.zip" 
wget https://github.com/dwkns/krep/archive/master.zip -O "$downloadFile" 
unzip -o "$downloadFile" -d "$HOME/Downloads" 
cp -vrf "$HOME/Downloads/krep-master/Krep.app" "/Applications" 
rm -rf "$HOME/Downloads/krep-master" 
rm -rf "$downloadFile" 
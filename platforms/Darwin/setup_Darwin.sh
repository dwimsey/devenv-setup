#/usr/bin/env sh
VAGRANTVERSION=1.8.5

echo OSX development environment boot script
echo You must have the XCode command line tools installed or this will fail.
echo Some parts of ansible must be compiled after installation, requiring the
echo XCode command line tools.  To verify, use:
echo .
echo pkgutil --pkg-info=com.apple.pkg.CLTools_Executables

# Install python package manager, "pip"
sudo easy_install pip
# Use pip to install ansible
sudo pip install ansible
# By running upgrade here, we make it so there is no issue running
# this script twice to ensure you always have the latest version
# Its duplicate work, but this is a 'get it running in 20 minutes or less'
# requirement
sudo pip install ansible --upgrade

curl -o ~/Downloads/Vagrant_${VAGRANTVERSION}.dmg https://releases.hashicorp.com/vagrant/${VAGRANTVERSION}/vagrant_${VAGRANTVERSION}.dmg
hdiutil attach ~/Downloads/Vagrant_${VAGRANTVERSION}.dmg

sudo installer -pkg /Volumes/Vagrant/Vagrant.pkg -target /

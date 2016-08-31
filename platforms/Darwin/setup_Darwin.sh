#/usr/bin/env sh
VAGRANTVERSION=1.8.5
VBPKGFILE=VirtualBox-5.1.2-108956-OSX.dmg
SSHKEYFILE="${HOME}/.ssh/id_rsa"

echo OSX development environment boot script
echo You must have the XCode command line tools installed or this will fail.
echo Some parts of ansible must be compiled after installation, requiring the
echo XCode command line tools.  To verify, use:
echo .
echo pkgutil --pkg-info=com.apple.pkg.CLTools_Executables

if [ ! -f "${HOME}/.ssh/id_rsa" ]; then
	echo Generating SSH private key ...
	ssh-keygen -f ${SSHKEYFILE}
fi

# Install python package manager, "pip"
sudo easy_install pip
# Use pip to install ansible
sudo pip install ansible
# By running upgrade here, we make it so there is no issue running
# this script twice to ensure you always have the latest version
# Its duplicate work, but this is a 'get it running in 20 minutes or less'
# requirement
sudo pip install ansible --upgrade

curl -o /tmp/Vagrant_${VAGRANTVERSION}.dmg https://releases.hashicorp.com/vagrant/${VAGRANTVERSION}/vagrant_${VAGRANTVERSION}.dmg
sudo hdiutil attach /tmp/Vagrant_${VAGRANTVERSION}.dmg
sudo installer -pkg /Volumes/Vagrant/Vagrant.pkg -target /
sudo hdiutil detach /Volumes/Vagrant

curl -o /tmp/${VBPKGFILE} http://download.virtualbox.org/virtualbox/5.1.2/${VBPKGFILE}
sudo hdiutil attach /tmp/${VBPKGFILE}
sudo installer -pkg /Volumes/VirtualBox/VirtualBox.pkg -target /
sudo hdiutil detach /Volumes/VirtualBox

# ARM Hard float ABI 64bit
# http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-linux-arm64-vfp-hflt.tar.gz

# Windows
# http://download.oracle.com/otn-pub/java/jdk/8u101-b13/jdk-8u101-windows-x64.exe

JDKPKGFILE=jdk-8u101-macosx-x64.dmg
curl -o /tmp/${JDKPKGFILE} -L -b "oraclelicense=a" http://download.oracle.com/otn-pub/java/jdk/8u101-b13/${JDKPKGFILE}
sudo hdiutil attach /tmp/${JDKPKGFILE}
sudo installer -pkg "/Volumes/JDK 8 Update 101/JDK 8 Update 101.pkg" -target /
sudo hdiutil detach "/Volumes/JDK 8 Update 101"

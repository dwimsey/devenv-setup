#/usr/bin/env sh
VAGRANTVERSION=1.8.5
INTELLIJVERSION=2016.2.2
INTELLIJEDITION=U
VBPKGFILE=VirtualBox-5.1.2-108956-OSX.dmg
JDKPKGFILE=jdk-8u101-macosx-x64.dmg
IJPKGFILE=ideaIU-2016.2.2.dmg
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

curl -o /tmp/${JDKPKGFILE} -L -b "oraclelicense=a" http://download.oracle.com/otn-pub/java/jdk/8u101-b13/${JDKPKGFILE}
sudo hdiutil attach /tmp/${JDKPKGFILE}
sudo installer -pkg "/Volumes/JDK 8 Update 101/JDK 8 Update 101.pkg" -target /
sudo hdiutil detach "/Volumes/JDK 8 Update 101"

# Install homebrew, lets us do maven easily

#/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#sudo brew install maven

MVNPKGFILE=apache-maven-3.3.9-bin.tar.gz
curl -L -o /tmp/${MVNPKGFILE} http://apache.claz.org/maven/maven-3/3.3.9/binaries/${MVNPKGFILE}
sudo mkdir -p /usr/local
tar zxf /tmp/${MVNPKGFILE}
mv apache-maven-3.3.9-bin /usr/local/maven
sudo chown -R root:staff /usr/local/maven
ln -s /usr/local/maven/bin/mvn /usr/local/bin

IJPKGFILE=ideaI${INTELLIJEDITION}-${INTELLIJVERSION}.dmg
curl -o /tmp/${IJPKGFILE} https://download-cf.jetbrains.com/idea/${IJPKGFILE}
sudo hdiutil attach /tmp/${IJPKGFILE}
sudo mv "/Volumes/IntelliJ IDEA/IntelliJ IDEA.app" /Applications
sudo hdiutil detach "/Volumes/IntelliJ IDEA"




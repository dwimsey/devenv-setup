#/usr/bin/env sh

platform='unknown'
unamestr=`uname`
if [ "$unamestr" = "Linux" ]; then
   platform='Linux'
elif [ "$unamestr" = "FreeBSD" ]; then
   platform='FreeBSD'
elif [ "$unamestr" = "Darwin" ]; then
   platform='Darwin'
else
	echo Unknown/Unsupported OS: ${unamestr}
fi

# You also probably want to extend the sudo password timeout, since its used alot
# The following will update the sudo config to use a 30 minute timeout, use -1 for no timeout, 0 to prompt for a password every time
#sudo sh -c 'echo "\nDefaults timestamp_timeout=-1">>/etc/sudoers'
## to undo, something like this works, adjust the -1 as needed to match the timeout in the file
## sudo sed -i "/Defaults timestamp_timeout=-1/d" /etc/sudoers

sh platforms/${platform}/setup_${platform}.sh

vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-reload

# Install the ansible IntelliJ plugin, so we can get our dev env setup easiest
#sudo ansible-galaxy install dwimsey.devenv
#sudo ansible-galaxy install dwimsey.devworkstation
#sudo ansible-galaxy install dwimsey.intellij
#sudo ansible-galaxy install jdauphant.intellij

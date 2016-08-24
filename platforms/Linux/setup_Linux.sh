#/usr/bin/env sh
VAGRANTVERSION=1.8.5
# Pull in OS Release info, so we can determine what we're running under, and the appropriate
# commands for that OS;  ID_LIKE would be 'debian' for ubuntu, or 'rhel fedora' for centos
. /etc/os-release

echo "     Platform: ${PRETTY_NAME}"
echo "  Platform ID: ${ID}, Like: ${ID_LIKE}"
# Add the ansible repo, this is no longer required.
#sudo apt-add-repository ppa:ansible/ansible -y

if [ "${ID_LIKE}" = 'debian' ]; then
	# Do the actual ansible install
	sudo apt-get update && sudo apt-get install virtualbox ansible vagrant -y
elif [ "${ID_LIKE}" = 'rhel fedora' ]; then
	# Do the actual ansible install
	sudo yum update && sudo yum install virtualbox ansible vagrant -y
fi

# Let our workstation setup script run locally
ansible all -i "localhost," -c local playbooks/devworkstation.yaml

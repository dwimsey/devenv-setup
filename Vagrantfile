# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Author: David Wimsey <david@wimsey.us>
#
# This Vagrant file allows us to rapidly configure a VM using the same scripts used to configure our dev environment
#Vagrant.require_plugin "vagrant-hostmanager"
#Vagrant.require_plugin "vagrant-vbguest"

boxes = {
		'devenv' => {
				:ip => '10.255.255.5',
				#:box => 'opentable/win-2012r2-standard-amd64-nocm',
				#:box => 'centos/7',
				:box => 'ubuntu/trusty64',
				:cpus => 2,
				:memory => 4096,
				:provision => 'ansible',
				#:ansible_ask_vault_pass => true,
				:ansible_playbook => 'playbooks/devworkstation.yml',
				:ansible_extra_vars => {
						is_vagrant: true,
						# The download isn't reliable for us, so we specify the path to the file here
						intellij_cached_copy: "~/Downloads/ideaIU-{{intellij_version}}{{intellij_pkg_extension}}",
				},
				:skip_vbguest_additions => false,
		}
}

# Identify user and SSH public key to be used in provisioning later
require 'etc'
user = Etc.getlogin
pubkey_path = "#{Dir.home}/.ssh/id_rsa.pub"
pubkey = File.readlines(pubkey_path).first.strip

# Main vagrant configuration
Vagrant.configure(2) do |config|

# Plugin hostmanager configuration
	config.hostmanager.enabled = true
	config.hostmanager.manage_host = true
	config.hostmanager.manage_guest = true

# Allow vagrant to SSH between VMs
	config.ssh.forward_agent = true
	config.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key']
	config.ssh.insert_key = false

	# We want to use the virtual box share rather than rsync so doesn't require any manual operations or lag between updates
	config.vm.synced_folder ".", "/vagrant", type: 'virtualbox'
	#config.vm.synced_folder "..", "/home/#{user}/project", type: 'virtualbox'

	boxes.each do |shortname, attrs|

		# Allow optional top level domain override and determine fully qualified hostname
		host_name = "#{shortname}.local"

		config.vm.define host_name do |node|

			# Main VM configuration
			node.vm.box = attrs[:box] || "centos/7"
			node.vm.hostname = host_name
			node.vm.network "private_network", ip: attrs[:ip]

			# Plugin hostmanager configuration
			node.hostmanager.aliases = shortname

			node.vm.provider "virtualbox" do |v|
				v.cpus = attrs[:cpus] || 2
				v.memory = attrs[:memory] || 1024
			end

			node.vbguest.no_install = attrs[:skip_vbguest_additions] || false

			node.vm.provision "shell" do |shell|
				shell.name   = "Removing hostname from /etc/hosts loopback line; source: http://stackoverflow.com/questions/33117939/vagrant-do-not-map-hostname-to-loopback-address-in-etc-hosts"
				shell.inline = "sed -ri 's/127\.0\.0\.1\s.*/127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4/' /etc/hosts"
			end

			if (attrs[:provision] == 'ansible')
				node.vm.provision "ansible" do |ansible|
					# The following two lines are not used in local mode
					#ansible.ask_vault_pass = attrs[:ansible_ask_vault_pass]|false
					#ansible.host_key_checking = false

					ansible.extra_vars = attrs[:ansible_extra_vars]
					# We let vagrant manage this file, it'll be in .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory
					ansible.playbook = attrs[:ansible_playbook]
					ansible.sudo = attrs[:ansible_use_sudo] || true
					ansible.verbose = ENV['ANSIBLE_VERBOSE'] || false

					if (attrs.has_key?(:ansible_limit))
						ansible.limit = attrs[:ansible_limit]
					end
				end
			end
		end
	end
end

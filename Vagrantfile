# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Author: David Wimsey <david@wimsey.us>
#

unless Vagrant.has_plugin?("vagrant-hostmanager")
	unless Vagrant.has_plugin?("vagrant-vbguest")
		raise 'You must install the vagrant hostmanager and vbguest plugins for this environment to work correctly: vagrant plugin install vagrant-hostmanager vagrant-vbguest'
	else
		raise 'You must install the vagrant hostmanager plugin for this environment to work correctly: vagrant plugin install vagrant-hostmanager'
	end
else
	unless Vagrant.has_plugin?("vagrant-vbguest")
		raise 'You must install the vagrant vbguest plugins for this environment to work correctly: vagrant plugin install vagrant-vbguest'
	end
end

boxes = {
		'devenv' => {
				:ip => '10.255.255.5',
				#:box => 'opentable/win-2012r2-standard-amd64-nocm',	# Windows 2012R2
				#:box => 'centos/7',																	# CentOS 7
				:box => 'ubuntu/trusty64',														# Ubuntu 14.04
				#:box => 'ubuntu/xenial64',														# Ubuntu 16.04
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
	# Plugin hostmanager configuration
	config.hostmanager.enabled = true
	config.hostmanager.manage_host = true
	config.hostmanager.manage_guest = true

	# Allow vagrant to SSH between VMs
	config.ssh.forward_agent = true
	config.ssh.private_key_path = ['~/.vagrant.d/insecure_private_key']
	config.ssh.insert_key = false

	# We want to use the virtual box share rather than rsync so doesn't require any manual operations or lag between updates
	#config.vm.synced_folder ".", "/vagrant", type: 'virtualbox', uid: "#{user}", gid: "#{user}"

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

			# Run the script which creates a user like ourselves and copies our ssh public key so we can ssh in quickly
			# This only supports UNIX at this time
			node.vm.provision "shell" do |shell|
				shell.name = "Creating privileged user account; user: #{user}, password: #{user}, public key file: #{pubkey_path}"
				shell.path = "createuser-self.sh"
				shell.args = [ user, pubkey ]
			end

			node.vm.provision "shell" do |shell|
				shell.name   = "Removing hostname from /etc/hosts loopback line; source: http://stackoverflow.com/questions/33117939/vagrant-do-not-map-hostname-to-loopback-address-in-etc-hosts"
				shell.inline = "sed -ri 's/127\.0\.0\.1\s.*/127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4/' /etc/hosts"
			end

			if (attrs[:provision] == 'ansible')
				if OS.windows?
					puts "Vagrant launched from windows, use at your own peril."
					ansible_mode = "ansible_local"
				else
					ansible_mode = "ansible"
				end

				node.vm.provision ansible_mode do |ansible|
					if ansible_mode != 'ansible_local'
						# The following two lines are not used in local mode
						ansible.ask_vault_pass = attrs[:ansible_ask_vault_pass]|false
						ansible.host_key_checking = false
					end

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

			if Vagrant.has_plugin?("vagrant-reload")
				node.vm.provision :reload
			else
				puts "You do not have the vagrant-reload plugin installed, please reboot this box: #{shortname} or run: vagrant plugin install vagrant-reload"
			end
		end
	end
end


module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def OS.mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def OS.unix?
        !OS.windows?
    end

    def OS.linux?
        OS.unix? and not OS.mac?
    end
end

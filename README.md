# Development Environment Quickstart Instructions

The instructions will provide you with the minimum required setup for developing software in Java.  The end result of this process will be a Linux virtual machine which provides all the nessacary dependancies and features required for developing software using IntelliJ

## Supported operating systems
Linux is the primary supported operating system at this time.  Mac OS X and Windows support is being added.

## Prerequisites

The following are the minimum requirements needed to start this provisioning process:

1. git - Git is required to access the source code repository and the scripts which will provide the base development environment.
2. bash - The initial configuration scripts are intended to be run from within the Bash shell.  This shell is available out of the box on all platforms except Windows, and is included with msys git on Windows.
3. Hardware Virtualization support (Testing) - Your CPU must support the POPCNT instruction and the Virtualization features must be enabled in your computers BIOS.  This configuration is beyond the scope of this document as it is unique to each hardware/BIOS combination.

### Linux
CentOS 7 and Ubuntu Linux can be used on workstations and is supported by these configuration/provisioning scripts.  The initial setup is slightly different between these operating systems just due to the difference in native package managers.

The supported Linux distrobutions come with Bash by default, the only external requirement to begin the provisioning process is git.  The remainder of the provisioning process can be handled entirely by the provisioning scripts after git is installed.  Based on the Linux distribution being targeted, use the appropriate section below:

#### Debian or Ubuntu
  Run the following command, sudo will require your user password to run as root:
```sh
sudo apt-get update && sudo apt-get install git python-27 -y
```
#### Redhat Enterprise Linux, Fedora or CentOS
  Run the following command, sudo will require your user password to run as root:
```sh
sudo yum update && sudo yum install git python-27
```
#### Mac OS X
OS X does not come with git by default, it is included with XCode from the Mac App Store.  Also if you simply run the git command from a local terminal window it will initiate a GUI prompt that will install the XCode command line tools.
  ```sh
  git --version
  ```
#### Microsoft Windows
Microsoft Windows can be used for most development work, however some aspects of the build process are unlikely to behave as expected on Windows.

NOTE: **Windows 10 is preferred!**  Windows 10 includes Hyper-V virtualization, which provide significant performance improvements to vagrant VMs and docker containers.

**The windows provisioning has not be implemented/documented/tested at this time.**

### The provisioning script
After the prerequisites are installed, the main provisioning script can be run.   This script will complete the provisioning process and provide a basic development environment capable of running the build, packaging, and testing.

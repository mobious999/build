The purpose of this script is to use powercli to build the shell of a virtual machine.

The process will be 

Build the shell of the vm
Upload a text file containing the mac address and name of the vm
Once the vm has been deployed another script will pull the name where mac address is x and then set the computer name.

At that point the configuration of the host will begin
- winrm
- powershell dsc / or ansible
- necessary software updates and installs
- Any desktop customizations
- Operating specific requirements
	- tcp offloading
	- Receive side scaling
	- other winsock specific settings per best practices
- Event log settings 
- windows updates

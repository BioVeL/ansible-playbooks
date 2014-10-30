# Cloud-init scripts

This folder contains a set of cloud-init user data scripts you can use with any
cloud-init enabled cloud and Ubuntu cloud-init enabled images.

To use the script, just download it, edit the SSH keys parameter with your public
SSH key for the bioveladm user and paste the full text into the user data attribute
of the VM creation request.

There are examples provided for:
 - portal: Start a BioVeL portal, with local R and Taverna server.
 - openrefine: Start an OpenRefine service, with SSL enabled.

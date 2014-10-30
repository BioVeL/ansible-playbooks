# Cloud-init scripts

This folder contains a set of cloud-init user data scripts you can use with
any cloud-init enabled cloud and Ubuntu cloud-init enabled images.

To use the scripts just download the one you need and edit appropriate
options. Then paste the full text into the user data attribute of the VM
creation request.

Note that on AWS VMs a standard user is setup already so these scripts do not
attempt to create another one.

There are examples provided for:
 - **Portal**: Start a BioVeL portal, with local R and Taverna server.
 - **OpenRefine**: Start an OpenRefine service, with SSL enabled.

# Ansible configuration for BioVeL servers


## Requirements

These playbooks are tested on Ubuntu 12.04.  There are likely to be issues 
using later versions of Ubuntu or other distributions.

There are definitely problems awaiting users of non-APT distributions - all 
the plays using `&apt` will need an equivalent for these other distributions.

For Portal versions 0.8, checkout the branch `master`.

For Portal versions 0.7/0.8 (up to 0.8.0-10585 SHA d8b2342), checkout the branch `player`.

For Portal versions 0.5/0.6, checkout the branch `legacy`.

For Portal versions 0.3.7/0.4.0, checkout the tag `portal0.4.0`.

The local host requires Python 2.7, and the Python YAML and Jinja2 libraries.
For Ubuntu 12.04, Python 2.7 should be installed. Install the other libraries
using:
```
$ sudo apt-get install python-yaml python-jinja2
```

## Configure ssh public key access

Setup password-less access to your hosts.  You should also have password-less
access to sudo on the host.  (If not, see the Ansible documentation for
additional flags).

Typically, this requires the command:
```
$ ssh-add <ssh-key>
```

## Setup

From the directory containing this README, run the command:
```
$ source setup.sh
```

This will install Ansible if required, and create additional files, such as a 
hosts file.


## Update the host inventory

Ensure the `inventory/hosts` file contains the hosts you wish to manage. You
can provide a short name by adding the `ansible_ssh_host` setting.

e.g. for a host called `portalhost.example.com`:
```
portalhost ansible_ssh_host=portalhost.example.com
```

Then add the short name under the groups to indicate which services you wish 
to deploy on the host, e.g. for a basic portal supporting workflows using 
local Rserve and Google Refine:

```
[taverna-server]
portalhost

# Rserve, accessible only to local clients
[rserve-local]
portalhost

# Rserve, accessible to remote network clients
[rserve-remote]

[biovel-portal]
portalhost

[taverna-workbench]

[google-refine]
portalhost
```

## Override default passwords

The files contained in the repository contain default usernames and passwords 
for services and databases.  You can use these, but anyone with access to the 
Github repository will know the passwords.

For additional security, copy the `group_vars` directory to the `playbooks` 
directory. e.g. `inventory/group_vars` -> `playbooks/group_vars` and override
the passwords.

If a host called `portalhost` is in the `biovel-portal` group, the default 
username and password for the portal's database will be obtained from 
`group_vars/biovel-portal`.

You can also create a host-specific file `playbooks/host_vars/portalhost` to 
override group definitions.  Do not add these files to the repository!


## Create a portal secured by a certificate

To create a secure Apache server, add certificate and key files to the Ansible 
directory `playbooks/apache-httpd/secure`

Create the file `playbooks/host_vars/<hostname>`, where `<hostname>` is the 
short name in the `hosts` file. Add the lines:
```
apache_https:
  hostname: <certificate-fqdn>
  privateKey: secure/<private-key-file>
  certificate: secure/<certificate-file>
  chainFile: secure/<ca-chain-file>
```

e.g. in file `playbooks/host_vars/portalhost`:
```
apache_https:
  hostname: portalhost.example.com
  privateKey: secure/host.key
  certificate: secure/host.crt
  chainFile: secure/chain.crt
```

## Transfer data from an existing portal

If you have an existing portal running, you can transfer the database from the
existing portal to the new portal using the following procedure:

Login to the source portal, and execute the command:
```
$ sudo <biovel-portal-install>/datactl.sh save <db-name> <data-zipfile>
```
e.g.
```
$ sudo /opt/BioVeLPortal/datactl.sh save tlite-prod data-20131024.zip
```

Transfer the file `<data-zipfile>` to your local host, and put it in the Ansible
directory `playbooks/biovel/portal/data/`

Create the file `playbooks/host_vars/<hostname>`, where `<hostname>` is the 
short name in the `hosts` file. Add the line:
```
biovel_portal_initial_data: data/<data-zipfile>
```
e.g. in file `playbooks/host_vars/portalhost`:
```
biovel_portal_initial_data: data/data-20131024.zip
```

Note that this only works when the database is first created. It cannot be
used to overwrite existing data.


## Configure the hosts

Simply run:
```
$ ansible-playbook -c ssh -i inventory/hosts playbooks/site.yaml
```

To configure a single host, append the flag `--limit <hostname>`

## Running via Cloud-Init

On cloud-init enabled cloud (such as Amazon and EGI Federated Cloud), you
can start a portal instance using a cloud-init user data script which starts
the ansible deployment locally and setup the portal environment.

Sample cloud-init user data is located in the `cloudinit` folder. To start
the deployment download the file, edit it with your SSH key (for accessing
the newly created VM) and put the text into the "user data" during VM
creation.

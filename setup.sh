#!/bin/sh

GITHUB_ANSIBLE=github-ansible

if [ ! -d ${GITHUB_ANSIBLE} ] ; then
	git clone https://github.com/ansible/ansible.git ${GITHUB_ANSIBLE}
fi
# Ensure all tags and commits are available
(cd ${GITHUB_ANSIBLE}; git fetch)
# Requires Ansible >= 9dec25854ea7b623cebd16fd6621ba39f592952d to install
# libxslt-dev package correctly
(cd ${GITHUB_ANSIBLE}; git checkout 9dec25854ea7b623cebd16fd6621ba39f592952d)
source ${GITHUB_ANSIBLE}/hacking/env-setup

if [ ! -r inventory/hosts ] ; then
  cp inventory/hosts-example inventory/hosts
fi

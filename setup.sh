#!/bin/sh

if [ ! -r inventory/hosts ] ; then
  cp inventory/hosts-example inventory/hosts
fi

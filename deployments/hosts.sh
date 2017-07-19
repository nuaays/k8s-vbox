#!/bin/bash

echo "adding $hostname $hostip to /etc/hosts"
echo -e "$hostip\t$hostname.box $hostname" >> /etc/hosts
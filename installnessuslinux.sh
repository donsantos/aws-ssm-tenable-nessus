#!/bin/bash

# Install Tenable Nessus Agent on Operating Systems listed below.

# List of Supported OS
AL=["Amazon Linux 2","Amazon Linux AMI 2018.03"]
RHEL7=["CentOS Linux 7 (Core)","Red Hat Enterprise Linux Server 7.0 (Maipo)","Red Hat Enterprise Linux Server 7.1 (Maipo)","Red Hat Enterprise Linux Server 7.2 (Maipo)","Red Hat Enterprise Linux Server 7.3 (Maipo)","Red Hat Enterprise Linux Server 7.4 (Maipo)","Red Hat Enterprise Linux Server 7.5 (Maipo)","Red Hat Enterprise Linux Server 7.6 (Maipo)","Red Hat Enterprise Linux Server 7.7 (Maipo)"]
UBNT=["Ubuntu 18.04.2 LTS","Ubuntu 16.04.6 LTS"]

#Grab OS Pretty Name of Host
OS=$(cat /etc/os-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g' | sed 's/["]//g' )

# Variables
TENABLE_KEY=""
TENABLE_HOST=""
TENABLE_PORT=""
TENABLE_AGENT_AMZN_URL=""
TENABLE_AGENT_UBNT_URL=""
TENABLE_AGENT_RHEL7_URL=""

echo "Start Nessus Agent Install"

if [[ $AL = *"$OS"* ]];
then
  # stop nessus if installed
  sudo systemctl stop nessusagent
  # Install wget
  sudo yum install wget -y 
  # Get Amazon Linux 2 Nessus RPM
  cd /tmp && sudo wget $TENABLE_AGENT_AMZN_URL
  # Install RPM
  cd /tmp && sudo rpm -ivh Nessus*.rpm
  # Start Nessus Ageent
  sudo systemctl restart nessusagent
  # Link Nessus Agent to Tenable Account
  sudo /opt/nessus_agent/sbin/nessuscli agent link --key=$TENABLE_KEY --groups="" --host=$TENABLE_HOST --port=$TENABLE_PORT
  # Clean up tmp
  cd /tmp && sudo rm -rf Nessus*.rpm
elif [[ $UBNT = *"$OS"* ]];
then
  # stop nessus if installed
  sudo systemctl stop nessusagent
  # Install wget
  sudo apt-get install wget -y
  # Get ES7 Nessus RPM
  cd /tmp && sudo wget $TENABLE_AGENT_UBNT_URL
  # Install RPM
  sudo  dpkg -i Nessus*.deb
  # Start Nessus Agent
  sudo systemctl restart nessusagent
  # Link Nessus Agent to Tenable Account
  sudo /opt/nessus_agent/sbin/nessuscli agent link --key=$TENABLE_KEY --groups="" --host=$TENABLE_HOST --port=$TENABLE_PORT
  # Clean up tmp
  cd /tmp && sudo rm -rf Nessus*.deb
elif [[ $RHEL7 = *"$OS"* ]];
then
  # stop nessus if installed
  sudo systemctl stop nessusagent
  # Install wget
  sudo yum install wget -y
  # Get ES7 Nessus RPM
  cd /tmp && sudo wget $TENABLE_AGENT_RHEL7_URL
  # Install RPM
  sudo  rpm -ivh NessusAgent-7.4.1-es7.x86_64.rpm
  # Start Nessus Agent
  sudo systemctl restart nessusagent
  # Link Nessus Agent to Tenable Account
  sudo /opt/nessus_agent/sbin/nessuscli agent link --key=$TENABLE_KEY --groups="" --host=$TENABLE_HOST --port=$TENABLE_PORT
  # Clean up tmp
  cd /tmp && sudo rm -rf Nessus*.rpm
else
  echo "No Supported OS"
fi

echo "Nessus Agent Install Complete"

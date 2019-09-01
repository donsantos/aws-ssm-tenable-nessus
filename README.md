# aws-ssm-tenable-nessus
AWS SSM document to install Tenable Nessus Agent on ec2 instances with SSM agent installed.

Because SSM can't distinguish linux flavors, I've written a small shell script that determines the OS flavor and installs the correct Nessus Linux Agent.
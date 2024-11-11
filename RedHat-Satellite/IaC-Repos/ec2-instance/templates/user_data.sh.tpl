#!/bin/bash

%{ if os_type == "Amazon Linux" ~}
yum update -y
amazon-linux-extras install epel -y
yum install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
%{ elif os_type == "Ubuntu" ~}
apt update -y
apt install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
%{ elif os_type == "Windows" ~}
# Windows SSM installation would be done by the AWS-provided user data
%{ endif ~}

# Run custom user data
${custom_script}

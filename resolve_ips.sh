#!/bin/bash
##############################################################################
## Script that resolves MWAA IPs to be used as lb_target_group_attachments  ##
##############################################################################

OUTPUT=$(dig CNAME +short $1)
# Enable after installing aws-cli
# OUTPUT=$( /usr/local/bin/aws ec2 describe-vpc-endpoints --profile estat-gitlab | grep $OUTPUT)
# ARR_OUT=($(echo $OUTPUT | tr '"' '\n'))
# OUTPUT=${ARR_OUT[2]}
FINAL=($(dig +short $1 $OUTPUT ))
mkdir -p ips
for ip in "${FINAL[@]}"  
do  
if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  touch ips/$ip
fi
done
ls ips

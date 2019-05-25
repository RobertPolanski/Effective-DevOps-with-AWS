#!/usr/bin/env bash
ansible --private-key ~/.ssh/EffectiveDevOpsAWS.pem ec2 -m ping
/usr/bin/ansible-pull -U https://github.com/RobertPolanski/Effective-DevOps-with-AWS-Second-Edition Chapter03/ansible/helloworld.yml -i localhost --sleep 60

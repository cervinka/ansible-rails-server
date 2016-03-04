#!/bin/bash

ansible-playbook $@ -u myapp -i inventory ../ansible/deploy.yml  # -vvvv

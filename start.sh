#!/bin/bash

export GITLAB_API_KEY=$GITLAB_API_KEY
sed -i "s/super_secret_key_from_gitlab/$GITLAB_API_KEY/g" /root/.gitlab.yml
source /etc/profile.d/rvm.sh
gitlab projects
/bin/bash

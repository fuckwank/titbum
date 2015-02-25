#!/bin/bash

export GITLAB_API_KEY=$GITLAB_API_KEY
sed -i "s/super_secret_key_from_gitlab/$GITLAB_API_KEY/g" /root/.gitlab.yml
source /etc/profile.d/rvm.sh
gitlab projects


cd /payload && \
./010-legislation-types.sh

/bin/bash

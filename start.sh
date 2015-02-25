#!/bin/bash

export GITLAB_API_KEY=$GITLAB_API_KEY
sed -i "s/super_secret_key_from_gitlab/$GITLAB_API_KEY/g" /root/.gitlab.yml
source /etc/profile.d/rvm.sh

export GITLAB_API_ENDPOINT="http://connectedgovernment.uk/api/v3"
export GITLAB_API_PRIVATE_TOKEN="$GITLAB_API_KEY"
gitlab projects


cd /payload

ssh-keygen -t rsa -C "admin@example.com"
gitlab create_ssh_key 1 "$(cat ~/.ssh/id_rsa.pub)"


git config --global user.name "Administrator"
git config --global user.email "admin@example.com"


#&& \
#./010-legislation-types.sh && \
#./040-act-walker.sh

/bin/bash

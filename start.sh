#!/bin/bash

export GITLAB_API_KEY=$GITLAB_API_KEY
sed -i "s/super_secret_key_from_gitlab/$GITLAB_API_KEY/g" /root/.gitlab.yml
source /etc/profile.d/rvm.sh

export GITLAB_API_ENDPOINT="http://connectedgovernment.uk/api/v3"
export GITLAB_API_PRIVATE_TOKEN="$GITLAB_API_KEY"
gitlab projects


cd /payload

#&& \
#./010-legislation-types.sh && \
#./040-act-walker.sh

/bin/bash

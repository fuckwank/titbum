FROM cannyos/ubuntu

# Install html2text and reporter utilitys
RUN apt-get update && \
  apt-get install -y python python-setuptools git curl build-essential python-dev libxml2-dev libxslt-dev python-dev libgd-dev python-matplotlib && \
  easy_install pip && \
  git clone https://github.com/ConnectedGovernment/html2text.git /root/html2text && \
  mv /root/html2text/html2text.py /bin/html2text && \
  curl https://pypi.python.org/packages/source/r/reporter/reporter-0.1.2.tar.gz > /root/reporter-0.1.2.tar.gz && \
  pip install /root/reporter-0.1.2.tar.gz && \
  tar -xvzf /root/reporter-0.1.2.tar.gz
  
  

ADD start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]

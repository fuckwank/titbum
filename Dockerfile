FROM cannyos/ubuntu

RUN apt-get update && \
  apt-get install -y python git curl && \
  git clone https://github.com/ConnectedGovernment/html2text.git /root/html2text && \
  mv /root/html2text/html2text.py /bin/html2text

ADD start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]

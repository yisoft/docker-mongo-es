FROM python:3.6.1-alpine

# env
ENV ETCDCTL_VERSION v3.1.6
ENV DUMB_INIT_VERSION 1.2.0
ENV MONGO_CONNECTOR_VERSION 'mongo-connector[elastic5]'

# Native dependencies
RUN \
    apk add --no-cache --update --virtual build-dependencies \
      wget \
      openssl \

    # Etcdctl
    && wget --no-check-certificate -O /tmp/etcd-$ETCDCTL_VERSION-linux-amd64.tar.gz https://github.com/coreos/etcd/releases/download/$ETCDCTL_VERSION/etcd-$ETCDCTL_VERSION-linux-amd64.tar.gz \
    && cd /tmp && gzip -dc etcd-$ETCDCTL_VERSION-linux-amd64.tar.gz | tar -xof -  \
    && cp -f /tmp/etcd-$ETCDCTL_VERSION-linux-amd64/etcdctl /usr/local/bin \

    # Dumb Init
    && wget --no-check-certificate  -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64 \
    && chmod +x /usr/bin/dumb-init \

    # Cleanup
    && apk del build-dependencies \
    && rm -rf ~/.cache /tmp/*


# Application dependencies
RUN pip3 install pyyaml
RUN pip3 install requests
RUN pip3 install $MONGO_CONNECTOR_VERSION

# add files
ADD . /opt/mongo-connector/
RUN chmod +x /opt/mongo-connector/run.sh

WORKDIR /opt/mongo-connector

CMD ["/usr/bin/dumb-init", "/opt/mongo-connector/run.sh"]

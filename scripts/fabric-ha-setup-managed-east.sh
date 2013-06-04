#!/bin/sh

JBOSS_FUSE_HOME=/root/opt/jboss-a-mq-6.0.0.redhat-024
export JBOSS_FUSE_HOME

CONTAINER_USERNAME=admin
CONTAINER_PASSWORD=admin
CONTAINER_SSH_HOST=localhost
CONTAINER_SSH_PORT=8101
ZOOKEEPER_PASSWORD=admin
ZOOKEEPER_URL=host117.phx.salab.redhat.com:2181

warn() {
    echo "${PROGNAME}: $*"
}

die() {
    warn "$*"
    exit 1
}

if [ "x$JBOSS_FUSE_HOME" != "x" ]; then
    if [ ! -d "$JBOSS_FUSE_HOME" ]; then
        die "JBOSS_FUSE_HOME is not valid: $JBOSS_FUSE_HOME"
    fi

    KARAF_CLIENT=$JBOSS_FUSE_HOME/bin/client

    if [ ! -x "$KARAF_CLIENT" ]; then
        die "JBOSS_FUSE_HOME is not valid: $JBOSS_FUSE_HOME"
    fi
fi

$KARAF_CLIENT -u $CONTAINER_USERNAME -p $CONTAINER_PASSWORD -h $CONTAINER_HOST -a $CONTAINER_SSH_PORT <<- end
    fabric:join --zookeeper-password $ZOOKEEPER_PASSWORD -p a-mq-east-broker $ZOOKEEPER_URL A-MQ-East
end
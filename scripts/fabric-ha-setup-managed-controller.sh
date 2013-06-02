#!/bin/sh

JBOSS_FUSE_HOME=~/opt/fuse/jboss-fuse-6.0.0.redhat-024
export JBOSS_FUSE_HOME

CONTAINER_USERNAME=admin
CONTAINER_PASSWORD=admin
CONTAINER_SSH_HOST=localhost
CONTAINER_SSH_PORT=8101
ZOOKEEPER_PASSWORD=admin

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

$KARAF_CLIENT -u $CONTAINER_USERNAME -p $CONTAINER_PASSWORD -h $CONTAINER_PASSWORD -a $CONTAINER_SSH_PORT <<- end
    fabric:create --clean --zookeeper-password $ZOOKEEPER_PASSWORD -p fmc root
    fabric:mq-create --group a-mq-east --networks a-mq-west --networks-username $CONTAINER_USERNAME --networks-password $CONTAINER_PASSWORD a-mq-east-profile
    fabric:mq-create --group a-mq-west --networks a-mq-east --networks-username $CONTAINER_USERNAME --networks-password $CONTAINER_PASSWORD a-mq-west-profile
end

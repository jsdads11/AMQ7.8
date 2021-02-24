#!/bin/bash

# This is the entry point for the docker images.
# This file is executed when docker run is called.

set -e

# BROKER_HOME=/var/lib/
BROKER_HOME=amq-broker-7.8.1/
CONFIG_PATH=$BROKER_HOME/etc
export BROKER_HOME OVERRIDE_PATH CONFIG_PATH

if [[ ${ANONYMOUS_LOGIN,,} == "true" ]]; then
  LOGIN_OPTION="--allow-anonymous"
else
  LOGIN_OPTION="--require-login"
fi

CREATE_ARGUMENTS="--user ${ARTEMIS_USER} --password ${ARTEMIS_PASSWORD} --silent ${LOGIN_OPTION} ${EXTRA_ARGS}"

echo CREATE_ARGUMENTS=${CREATE_ARGUMENTS}

if ! [ -f ./etc/broker.xml ]; then
    ./$BROKER_HOME/bin/artemis create ${CREATE_ARGUMENTS} .
else
    echo "broker already created, ignoring creation"
fi

exec ./bin/artemis "$@"


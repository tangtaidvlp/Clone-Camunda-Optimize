#!/bin/bash

####################################################################################################################
#                                                                                                                  #
#                                        Optimize Upgrade Script                                                   #
#                                                                                                                  #
#   Performs incremental upgrade of elasticsearch indexes and data structures to current version from previous.    #
#                                                                                                                  #
####################################################################################################################

cd $(dirname "$0")
BASEDIR=$(pwd)
export PLUGIN_DIR="${BASEDIR}/../plugin"

# now set the path to java
if [ -x "$JAVA_HOME/bin/java" ]; then
  JAVA="$JAVA_HOME/bin/java"
else
  set +e
  JAVA=`which java`
  set -e
fi

# check if there are custom JVM options set.
if [ -z "$OPTIMIZE_JAVA_OPTS" ]; then
  OPTIMIZE_JAVA_OPTS="-Xms128m -Xmx512m -XX:MetaspaceSize=64m -XX:MaxMetaspaceSize=256m"
fi

# Set up the classpath
OPTIMIZE_CLASSPATH=$BASEDIR/../config:${BASEDIR}/../lib/*:$BASEDIR/*:$BASEDIR/../optimize-backend-3.9.0-preview-1.jar

echo
echo "Starting Camunda Optimize Upgrade to 3.9.0-preview-1...";
echo

exec $JAVA ${OPTIMIZE_JAVA_OPTS} -cp "$OPTIMIZE_CLASSPATH" -Dfile.encoding=UTF-8 org.camunda.optimize.upgrade.main.UpgradeMain $1

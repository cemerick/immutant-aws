#!/usr/bin/env bash

set -e

# TODOs:

if [ -e "/vagrant" ]; then
    VAGRANT=y
    RESOURCES=/vagrant
else
    RESOURCES=.
fi

source $RESOURCES/immutant.conf

# so that maintainers/contributors have a place to put credentials that won't
# end up in the repo
if [ -e "$RESOURCES/immutant.local.conf" ]; then
    source $RESOURCES/immutant.local.conf
fi

#### Java
apt-get -y update
apt-get -y install python-software-properties # gives us add-apt-repository
add-apt-repository -y ppa:webupd8team/java
apt-get -y update
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
apt-get -y install oracle-java7-installer unzip curl vim

#### Leiningen
# mkdir ~/bin
# curl https://raw.github.com/technomancy/leiningen/stable/bin/lein -o ~/bin/lein
# chmod +x ~/bin/lein
# export PATH=$PATH:~/bin
# # seems bad, but don't want to muss with running everything under
# # another user at the moment
# export LEIN_ROOT=y 
# lein self-install

#### Immutant
sudo useradd -m immutant
JBOSS_LOG_DIR=/var/log/jboss-as
mkdir -p $IMMUTANT_DIR $JBOSS_LOG_DIR

# echo '{:user {:plugins [[lein-immutant "1.0.1"]]}}' > ~/.lein/profiles.clj
# lein immutant install 1.0.1
IMMUTANT_DIST=$IMMUTANT_REV-slim
wget http://downloads.immutant.org/release/org/immutant/immutant-dist/$IMMUTANT_REV/immutant-dist-$IMMUTANT_DIST.zip
unzip immutant-dist-$IMMUTANT_DIST.zip
mv immutant-$IMMUTANT_DIST/jboss/* $IMMUTANT_DIR

chown immutant:immutant -R $IMMUTANT_DIR $JBOSS_LOG_DIR 

##### swap in AWS-enabled config
STANDALONE_CONF=$IMMUTANT_DIR/standalone/configuration/standalone-ha.xml
if [ ! -f "$STANDALONE_CONF.orig" ]; then
    mv $STANDALONE_CONF $STANDALONE_CONF.orig
fi
cp $RESOURCES/standalone-ha-ec2-template.xml $STANDALONE_CONF
if [ -z "$S3_PING_BUCKET" ]; then
    echo "WARNING, $S3_PING_BUCKET not defined, clustering will fail on AWS."
    exit 1
fi
if [ -z "$S3_PING_SECRET_KEY" ]; then
    echo "WARNING, $S3_PING_SECRET_KEY not defined, clustering will fail on AWS."
    exit 1
fi
if [ -z "$S3_PING_ACCESS_KEY" ]; then
    echo "WARNING, $S3_PING_ACCESS_KEY not defined, clustering will fail on AWS."
    exit 1
fi
for var in PUBLIC_NETWORK_IF S3_PING_SECRET_KEY S3_PING_ACCESS_KEY S3_PING_BUCKET; do
    _val=$(eval "echo \$$var")
    _val=${_val//\//\\/}
    sed -i s/\$$var/$_val/g $STANDALONE_CONF
done

#### bootstrap deployment
# this is just getting silly...
# $IMMUTANT_INIT_DEPLOY=$IMMUTANT_DIR/immutant-initial-deploy.sh
# cat > $IMMUTANT_INIT_DEPLOY <<DEPLOY_EOF
# #!/usr/bin/env bash
# 
# IMMUTANT_DEPLOY=$IMMUTANT_DIR/standalone/deployments
# if [ -z "$INIT_IMA" ]; then
#     echo "Deploying initial application from $INIT_IMA"
#     pushd $IMMUTANT_DEPLOY
#     INIT_IMA_PATH=$IMMUTANT_DEPLOY/INIT_IMA.ima
#     curl "$INIT_IMA" -o $INIT_IMA_PATH
# 
#     cat > $INIT_IMA_PATH.clj <<EOF
# {:root "$INIT_IMA_PATH" :lein-profiles [:production]} 
# EOF
#     touch $INIT_IMA_PATH.clj.dodeploy
#     popd
# fi
# DEPLOY_EOF
# chmod +x $IMMUTANT_INIT_DEPLOY

#### daemonizing
mkdir -p /etc/jboss-as
cp $RESOURCES/jboss-as.conf /etc/jboss-as/
cp $RESOURCES/jboss-as-standalone.sh /etc/init.d/jboss-standalone
update-rc.d jboss-standalone defaults

exit 0

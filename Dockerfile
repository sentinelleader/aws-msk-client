FROM openjdk:17-jdk-alpine3.14

ENV KAFKA_PLUGINS="/usr/local/share/kafka/plugins"
ENV KAFKA_VERSION="2.8.1"
ENV KAFKA_PACKAGE="kafka_2.13-2.8.1"
ENV AWS_MSK_IAM_AUTH="1.1.1"

RUN apk add --no-cache curl wget tar bash jq vim

# setup java truststore
RUN cp $JAVA_HOME/lib/security/cacerts /tmp/kafka.client.truststore.jks

# install kafka
RUN wget https://downloads.apache.org/kafka/$KAFKA_VERSION/$KAFKA_PACKAGE.tgz \
    && tar -xzf $KAFKA_PACKAGE.tgz \
    && rm -rf $KAFKA_PACKAGE.tgz

# setup kafka plugins directory
RUN mkdir -p $KAFKA_PLUGINS

# install aws-msk-iam-auth jar for kafka and kafka connect CLIs
# https://github.com/aws/aws-msk-iam-auth/releases/download/v1.1.1/aws-msk-iam-auth-1.1.1-all.jar
RUN wget https://github.com/aws/aws-msk-iam-auth/releases/download/v$AWS_MSK_IAM_AUTH/aws-msk-iam-auth-$AWS_MSK_IAM_AUTH-all.jar \
    && cp aws-msk-iam-auth-$AWS_MSK_IAM_AUTH-all.jar $KAFKA_PLUGINS/ \
    && mv aws-msk-iam-auth-$AWS_MSK_IAM_AUTH-all.jar /$KAFKA_PACKAGE/libs/

WORKDIR /$KAFKA_PACKAGE

ENTRYPOINT ["/bin/bash", "-l", "-c"]

CMD ["tail -f /dev/null"]


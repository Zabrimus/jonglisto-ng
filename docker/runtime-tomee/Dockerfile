FROM anapsix/alpine-java:8u152b16_server-jre

ENV PATH /usr/local/tomee/bin:$PATH
RUN mkdir -p /usr/local/tomee

WORKDIR /usr/local/tomee

RUN set -x \
    && apk upgrade --update \
    && apk add --no-cache curl \
    && curl -fSL https://repo.maven.apache.org/maven2/org/apache/tomee/apache-tomee/7.0.4/apache-tomee-7.0.4-webprofile.tar.gz -o tomee.tar.gz \
    && tar -zxf tomee.tar.gz \
    && mv apache-tomee-webprofile-7.0.4/* /usr/local/tomee \
    && rm -Rf apache-tomee-webprofile-7.0.4 \
    && rm bin/*.bat \
    && rm tomee.tar.gz* \
    && rm -Rf /usr/local/tomee/webapps/* \
    && mkdir /etc/jonglisto \
    && mkdir /var/jonglisto-ng 

ADD jonglisto-ng-0.0.3-snapshot.war /usr/local/tomee/webapps/jonglisto-ng.war
ADD jonglisto-ng.xml /etc/jonglisto
ADD remote.xml /etc/jonglisto
ADD security.ini /etc/jonglisto

EXPOSE 8080
CMD ["catalina.sh", "run"]

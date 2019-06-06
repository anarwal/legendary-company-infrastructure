FROM sonatype/nexus3
MAINTAINER Abhimanyu Narwal <anarwal.27@gmail.com>

ARG NEXUS_DOMAIN
ENV NEXUS_DOMAIN ${NEXUS_DOMAIN}

USER root

RUN cd /opt/sonatype/nexus/etc/ssl \
         && keytool -genkeypair -keystore keystore.jks -storepass password -keypass password -alias jetty -keyalg RSA -keysize 2048 -validity 5000 -dname "CN=${NEXUS_DOMAIN}, OU=OU, O=ORG, L=Manhattan, ST=NY, C=US" -ext "SAN=DNS:${NEXUS_DOMAIN}" -ext "BC=ca:true"

RUN sed \
     -e '/^nexus-args/ s:$:,${jetty.etc}/jetty-https.xml:' \
     -e '/^nexus-args/ s:$:,${jetty.etc}/jetty-http-redirect-to-https.xml:' \
     -e '/^application-port/a \
 application-port-ssl=8443\
 ' \
     -i opt/sonatype/nexus/etc/nexus-default.properties

RUN sed -e '/^nexus soft/a nexus - nofile 65536' -i /etc/security/limits.conf

EXPOSE 8443
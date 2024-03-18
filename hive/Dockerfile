FROM docker.io/apache/hive:4.0.0-beta-1

USER root

ADD ./tmp2/postgresql.jar /opt/hive/lib/

RUN mkdir -p /home/hive /tmp/hive /user/hive \
  && useradd -ms /bin/bash -d /home/hive hive || true \
  && chmod -R a+rw /home/hive /tmp/hive /user/hive \
  && chown -R hive:hive /home/hive /tmp/hive /user/hive

USER hive

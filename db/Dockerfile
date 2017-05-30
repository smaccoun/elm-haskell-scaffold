FROM postgres:9.6

ADD ./tables/init-ddl.sql ./tables/init-data.sql /
RUN cat /init-ddl.sql /init-data.sql  >> /docker-entrypoint-initdb.d/init-db.sql

ENV POSTGRES_USER dara
ENV POSTGRES_PASSWORD dara
ENV POSTGRES_DB dara
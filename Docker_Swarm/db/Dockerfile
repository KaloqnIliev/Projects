FROM mysql:5.7

ENV MYSQL_ROOT_PASSWORD password
ENV MYSQL_DATABASE Users

EXPOSE 3306

COPY ./sql-scripts/ /docker-entrypoint-initdb.d/

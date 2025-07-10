FROM httpd:2.4

ARG SERVER_NAME=localhost
ARG SERVER_ADMIN=admin@localhost

COPY tls/server.key /usr/local/apache2/conf/server.key
COPY tls/server.crt /usr/local/apache2/conf/server.crt
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
COPY index.html /usr/local/apache2/htdocs/index.html
COPY httpd-ssl.conf /usr/local/apache2/conf/extra/httpd-ssl.conf

RUN sed -i "s!#ServerName www.example.com:80!ServerName ${SERVER_NAME}:80!" /usr/local/apache2/conf/httpd.conf
RUN sed -i "s!ServerAdmin you@example.com!ServerAdmin ${SERVER_ADMIN}!" /usr/local/apache2/conf/httpd.conf

RUN sed -i "s!ServerName www.example.com:443!ServerName ${SERVER_NAME}:443!" /usr/local/apache2/conf/extra/httpd-ssl.conf
RUN sed -i "s!ServerAdmin you@example.com!ServerAdmin ${SERVER_ADMIN}!" /usr/local/apache2/conf/extra/httpd-ssl.conf



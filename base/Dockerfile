FROM take4iso/odtiles-base:latest

ARG URL
ARG ALLOWED_HOSTS
ARG UWSGI_WORKERS
ARG UWSGI_PORT
ARG TILE_SOURCE_FOLDER
ARG TILE_OUTPUT_FOLDER
ARG WMS_OUTPUT_FOLDER
ARG MAX_AGE
ARG MAX_AGE_LIVE

RUN sed -i "s!URL = 'http://localhost:8000'!URL = '${URL}'!" /opt/odtiles/odtiles/settings.py
RUN  result="" && \
    IFS=',' read -ra ADDR <<< "$ALLOWED_HOSTS" && \
    for i in "${ADDR[@]}"; do \
    result="$result'$i',"; \
    done && \
    result="[${result%,}]" && \
    sed -i "s!ALLOWED_HOSTS=\['localhost'\]!ALLOWED_HOSTS=${result}!" /opt/odtiles/odtiles/settings.py
RUN sed -i "s!workers = 8!workers = ${UWSGI_WORKERS}!" /opt/odtiles/odtiles/uwsgi.ini
RUN sed -i "s!socket = 0.0.0.0:8080!socket = 0.0.0.0:${UWSGI_PORT}!" /opt/odtiles/odtiles/uwsgi.ini
RUN sed -i "s!MAX_AGE = 86400!MAX_AGE = ${MAX_AGE}!" /opt/odtiles/odtiles/settings.py
RUN sed -i "s!MAX_AGE_LIVE = 60!MAX_AGE_LIVE = ${MAX_AGE_LIVE}!" /opt/odtiles/odtiles/settings.py
# tilecache_rotate.sh
COPY tilecache_rotate.sh /opt/odtiles/tilecache_rotate.sh
RUN chmod +x /opt/odtiles/tilecache_rotate.sh

# タイムゾーン変更
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

#
# cronをインストールして，タイルキャッシュのローテートを設定する場合は以下を全部有効にする
#
# RUN dnf update && dnf install -y cronie
# RUN sed -i -e '/pam_loginuid.so/s/^/#/' /etc/pam.d/crond
# ADD logrotate.d /etc/logrotate.d/
# ADD cron.d /etc/cron.d/
# RUN chmod 0644 /etc/cron.d/*
# RUN sed -i '4i crond' /opt/odtiles/start.sh




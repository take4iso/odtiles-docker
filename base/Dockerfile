FROM take4iso/odtiles-base:latest

ARG SERVER_NAME
ARG UWSGI_WORKERS
ARG UWSGI_PORT
ARG TILE_SOURCE_FOLDER
ARG TILE_OUTPUT_FOLDER
ARG TILE_MAX_AGE
ARG TILE_MAX_AGE_LIVE

RUN sed -i "s!ALLOWED_HOSTS = ['localhost']!ALLOWED_HOSTS = ['${SERVER_NAME}']!" /opt/odtiles/odtiles/settings.py
RUN sed -i "s!CSRF_TRUSTED_ORIGINS = ['http://locslhost']!CSRF_TRUSTED_ORIGINS = ['http://${SERVER_NAME}','https://${SERVER_NAME}']!" /opt/odtiles/odtiles/settings.py
RUN sed -i "s!workers = 8!workers = ${UWSGI_WORKERS}!" /opt/odtiles/odtiles/uwsgi.ini
RUN sed -i "s!socket = 0.0.0.0:8080!socket = ${UWSGI_PORT}!" /opt/odtiles/odtiles/uwsgi.ini
# ホストのフォルダをバインドドマウントするので、ここでは変更しない
#RUN sed -i "s!TILE_SOURCE_FOLDER = '/mnt/odtiles/tilesrc'!TILE_SOURCE_FOLDER = '${TILE_SOURCE_FOLDER}'!" /opt/odtiles/odtiles/settings.py
#RUN sed -i "s!TILE_OUTPUT_FOLDER = '/mnt/odtiles/tileout'!TILE_OUTPUT_FOLDER = '${TILE_OUTPUT_FOLDER}'!" /opt/odtiles/odtiles/settings.py
RUN sed -i "s!TILE_MAX_AGE = 86400!TILE_MAX_AGE = ${TILE_MAX_AGE}!" /opt/odtiles/odtiles/settings.py
RUN sed -i "s!TILE_MAX_AGE_LIVE = 60!TILE_MAX_AGE_LIVE = ${TILE_MAX_AGE_LIVE}!" /opt/odtiles/odtiles/settings.py
# tilecache_rotate.sh
COPY tilecache_rotate.sh /opt/odtiles/tilecache_rotate.sh
RUN chmod +x /opt/odtiles/tilecache_rotate.sh

# タイムゾーン変更
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime


# cronをインストールして，タイルキャッシュのローテートを設定する場合は以下を全部有効にする
# cronを入れる
# RUN dnf update && dnf install -y cronie

# PAMの設定
# RUN sed -i -e '/pam_loginuid.so/s/^/#/' /etc/pam.d/crond

# rogrotateとcronの設定ファイルを追加
# ADD logrotate.d /etc/logrotate.d/
# ADD cron.d /etc/cron.d/
# RUN chmod 0644 /etc/cron.d/*

# start.sh にcronの起動を追加
# RUN sed -i '4i crond' /opt/odtiles/start.sh




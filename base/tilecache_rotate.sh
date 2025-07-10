#!/bin/bash

# DockerコンテナのENTRYPOINT
export LD_LIBRARY_PATH=/usr/lib

find /mnt/odtiles/tileout -type d -mtime 10 | xargs rm -fr

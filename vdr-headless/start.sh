#!/bin/sh

rsyslogd
#service ssh start

service vdr start
exec tail -f /dev/null
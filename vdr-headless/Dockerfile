FROM ubuntu:22.04
#MAINTAINER chriszero <zerov83@gmail.com>

WORKDIR /tmp

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update
RUN apt install -y gnupg

RUN apt-get install -y software-properties-common
RUN add-apt-repository -s -y ppa:seahawk1986-hotmail/jammy-vdr
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 272A2CE18103B360 F529E113D0A5897C \
#RUN echo deb https://ppa.launchpadcontent.net/seahawk1986-hotmail/jammy-vdr/ubuntu jammy main   > /etc/apt/sources.list.d/yavdr.list \
# && echo deb-src https://ppa.launchpadcontent.net/seahawk1986-hotmail/jammy-vdr/ubuntu jammy main  >> /etc/apt/sources.list.d/yavdr.list
 #&& echo deb http://ppa.launchpad.net/yavdr/stable-yavdr/ubuntu jammy main >> /etc/apt/sources.list.d/yavdr.list \
 #&& echo deb http://ppa.launchpad.net/gandalf-der-grosse/main/ubuntu jammy main  > /etc/apt/sources.list.d/gandalf.list \
 #&& echo deb http://ppa.launchpad.net/gandalf-der-grosse/stable-vdr/ubuntu jammy main  >> /etc/apt/sources.list.d/gandalf.list

RUN apt-get update -qq && \
	apt-get install -qy \
	wget \
	vdr \
	rsyslog \
	vdr-plugin-epgsearch \
	vdr-plugin-femon \
	vdr-plugin-satip \
	vdr-plugin-live \
	vdr-plugin-restfulapi \
	vdr-plugin-vnsiserver \
	vdr-plugin-vdrmanager
RUN apt install -y vdr-plugin-svdrpservice \
 	vdr-plugin-streamdev-server \
 	vdr-plugin-svdrposd \
	ffmpeg \
#	libmariadb3 uuid \
# 	libxml2 \
#	nano hunspell && \
	nano git openssh-server bash-completion iproute2 net-tools
# 	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



RUN apt-get install -qy build-essential ccache
RUN apt-get build-dep -qy vdr
RUN  apt source vdr
RUN git clone --depth 1 --branch v2.2.6 https://github.com/manio/vdr-plugin-dvbapi.git
# wechslt ins vdr verzeichnis
RUN cd $(ls -d vdr*/|head -n 1)/PLUGINS/src && \
	rm -fr * && \ 
	ln -s ../../../vdr-plugin-dvbapi dvbapi
RUN cd $(ls -d vdr*/|head -n 1) && \
	make plugins && make install-plugins



COPY vdr.sh /etc/services.d/vdr/run
#COPY vdr-finish.sh /etc/services.d/vdr/finish
COPY rsyslog.sh /etc/services.d/rsyslog/run

# # Configure the vdr user account and it's folders
 RUN groupmod -o -g 666 vdr \
  && usermod -o -u 666 vdr \
  && install -o vdr -g vdr -d /srv/vdr/video /vdr/config /vdr/cache
 
# # add configs
 COPY var/lib/vdr/* /var/lib/vdr/
 COPY var/lib/vdr/plugins/streamdev-server/* /var/lib/vdr/plugins/streamdev-server/
 COPY etc/vdr/conf.d/* /etc/vdr/conf.d/
 COPY etc/default/vdr /etc/default/vdr
 COPY start.sh /root/start.sh
RUN rm /etc/vdr/plugins/streamdevhosts.conf
RUN ln -s /var/lib/vdr/plugins/streamdev-server/streamdevhosts.conf /etc/vdr/plugins/streamdevhosts.conf
RUN chmod u+x /root/start.sh
RUN rm /etc/vdr/conf.d/50-satip.conf
 #COPY etc/rsyslog.conf /etc/

 EXPOSE 2004 3000 6419 8002 8008 4010-4020/udp 34890 8875 554 1900/udp
 VOLUME /srv/vdr/video  /etc/vdr /vdr/config /vdr/cache

#_RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*






ENTRYPOINT ["/root/start.sh"]


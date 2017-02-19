FROM philcryer/min-jessie

MAINTAINER Alexander pipelka <alexander.pipelka@gmail.com>

USER root

ENV DVBAPI_ENABLE="0"
ENV DVBAPI_HOST="127.0.0.1"
ENV DVBAPI_PORT="2000"

ENV SATIP_NUMDEVICES="2"
ENV SATIP_SERVER="192.168.16.10"

ENV ROBOTV_TIMESHIFTDIR="/video"
ENV ROBOTV_MAXTIMESHIFTSIZE="4000000000"
ENV ROBOTV_PICONSURL=
ENV ROBOTV_SERIESFOLDER="Serien"
ENV ROBOTV_CHANNELCACHE="true"
ENV ROBOTV_EPGIMAGEURL=

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
	libfreetype6 libfontconfig1 libjpeg62-turbo \
	libpugixml1 libcurl3 && \
    apt-get clean

RUN mkdir -p /opt && mkdir -p /data && mkdir -p /video && mkdir -p /opt/templates

COPY opt /opt/
COPY runvdr.sh /opt/vdr/
COPY templates/diseqc.conf /opt/templates/
COPY templates/sources.conf /opt/templates/
COPY templates/channels.conf /opt/templates/

RUN chmod +x /opt/vdr/runvdr.sh

RUN apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y
#RUN cp -R /usr/share/locale/en\@* /tmp/ && rm -rf /usr/share/locale/* && mv /tmp/en\@* /usr/share/locale/
RUN rm -rf /usr/share/locale/*
RUN rm -rf /var/cache/debconf/*-old && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/* \
    rm -rf /usr/share/man

#RUN locale-gen en_US.UTF-8
#RUN echo "LANG=\"en_US.UTF-8\"" > /etc/default/locale

ENTRYPOINT [ "/opt/vdr/runvdr.sh" ]

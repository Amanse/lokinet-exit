FROM ubuntu:latest
EXPOSE 8080
RUN apt update -y  && \
    apt install curl -y  && \
    apt install unrar -y  && \
    apt install unzip -y  && \
    apt update
    apt install node -y && \
    apt install npm -y && \
    mkdir /Essential-Files && \

COPY Essential-Files /Essential-Files
RUN chmod +x /Essential-Files/entrypoint.sh
CMD /Essential-Files/entrypoint.sh

FROM registry.oxen.rocks/lokinet-base:latest

# set up configs for lokinet
COPY contrib/lokinet-exit.ini /var/lib/lokinet/conf.d/exit.ini

# set up system configs
COPY contrib/lokinet-exit-sysctl.conf /etc/sysctl.d/00-lokinet-exit.conf
COPY contrib/lokinet-exit-rc.local.sh /etc/rc.local
RUN /bin/bash -c 'chmod 700 /etc/rc.local'

COPY contrib/print-lokinet-address.sh /usr/local/bin/print-lokinet-address.sh
RUN /bin/bash -c 'chmod 700 /usr/local/bin/print-lokinet-address.sh'

# setup cron jobs
COPY contrib/lokinet-kill-scans.sh /usr/local/bin/lokinet-kill-scans.sh
RUN /bin/bash -c 'chmod 700 /usr/local/bin/lokinet-kill-scans.sh'
COPY contrib/lokinet-update-exit-address.sh /usr/local/bin/lokinet-update-exit-address.sh
RUN /bin/bash -c 'chmod 700 /usr/local/bin/lokinet-update-exit-address.sh'

COPY contrib/lokinet-exit.crontab /etc/cron.d/lokinet-exit
RUN /bin/bash -c 'chmod 644 /etc/cron.d/lokinet-exit'

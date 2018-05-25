FROM registry.access.redhat.com/rhel:7.4

ENV LANG=en_US.UTF-8 \
    INSTALL_PKGS="nmap net-tools telnet traceroute openssl tar rsync curl wget" \
    USER=nonroot \
    USERHOME=/home/${USER}
    
#RUN localedef -i en_US -f UTF-8 en_US.UTF-8

# You could remove the yum update, if you dont want to update other packages
RUN yum update -y --setopt=tsflags=nodocs \
    && yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS \
    && rpm -V $INSTALL_PKGS \
    && yum clean all \
    && rm -rf /var/cache/yum

COPY startup.sh /sbin/startup.sh
RUN chmod +x /sbin/startup.sh

# setup user and home dir
RUN mkdir -p ${USERHOME}/

WORKDIR ${USERHOME}

# Reset permissions of modified directories and add default user
RUN useradd -u 1001 -r -g 0 -d ${USERHOME} -s /sbin/nologin -c "Default Application User" default \
	&& chown -R 1001:0 ${USERHOME}

CMD ["startup.sh"]

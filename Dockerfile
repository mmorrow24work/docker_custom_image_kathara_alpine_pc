FROM alpine:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apk add --no-cache \
    zabbix-agent \
    net-snmp \
    net-snmp-tools \
    iproute2-tc \
    softflowd \
    iproute2 \
    iputils \
    bash \
    iperf3

# Configure SNMPD: minimal snmpd.conf with trap target and community "public"
RUN echo -e "\
com2sec readonly  default         public\n\
group   myv1group v1            readonly\n\
group   myv2cgroup v2c          readonly\n\
view    all       included      .1\n\
access  myv1group \"\"      any       noauth    exact  all    none   none\n\
access  myv2cgroup \"\"      any       noauth    exact  all    none   none\n\
sysLocation Alpine Kathara PC\n\
sysContact admin@example.com\n\
trap2sink snmpmanager\n" > /etc/snmp/snmpd.conf

# Configure Zabbix Agent: update Server and Hostname for flexibility
RUN sed -i \
    -e 's/^Server=127.0.0.1/Server=192.168.10.7/' \
    -e 's/^Hostname=Zabbix server/Hostname=kathara-pc/' \
    /etc/zabbix/zabbix_agentd.conf

# Expose SNMP (161/udp), Zabbix agent port (10050/tcp), softflowd (2055/udp)
EXPOSE 161/udp 10050/tcp 2055/udp

# Start all required services and keep container running
CMD snmpd -f -Lo -c /etc/snmp/snmpd.conf & \
    softflowd -i eth0 -n 192.168.10.6:2055 -v 5 -b -T & \
    zabbix_agentd -f

# Make chnages to the Zabbix Agent settings to allow host to be managed by the Zabbix server
# COPY docker-entrypoint.sh /usr/local/bin/
# RUN chmod +x /usr/local/bin/docker-entrypoint.sh


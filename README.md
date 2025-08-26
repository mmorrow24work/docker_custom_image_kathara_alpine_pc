
# dockerfile used to create the custom docker image used with kathara - alpine_pc

Mick Morrow  | Solutions Architect
Email: Mick.Morrow@telent.com
Mobile: 07974398922
Web: www.telent.com

I created this dockerfile for the customer docker image I use for my digital twin kathara lab.conf - see extract below :

```bash
WSL-Ubuntu 24.04.1 LTS:$ cat lab.conf
LAB_DESCRIPTION="Network Configuration Scenario – IS#33B"
LAB_VERSION=1.0
LAB_AUTHOR="Mick Morrow _ Solutions Architect"
LAB_EMAIL=Mick.Morrow@telent.com
LAB_WEB=https://telent.com/

snmp_manager[0]="sms"
snmp_manager[bridged]="true"
snmp_manager[image]="zabbix7.4-ubuntu24"
snmp_manager[port]="8080:80/tcp"
snmp_manager[port]="10051:10051/tcp"
snmp_manager[port]="10050:10050/tcp"

netflowcollector[0]="sms"
netflowcollector[image]="alpine_pc"

pc1[0]="sms"
pc1[image]="alpine_pc"

pc2[0]="24"
pc2[image]="alpine_pc"

WSL-Ubuntu 24.04.1 LTS:$
```

***

* Install required packages
* Configure SNMPD: minimal snmpd.conf with trap target and community "public"
* Configure Zabbix Agent: update Server and Hostname for flexibility
* Expose SNMP (161/udp), Zabbix agent port (10050/tcp), softflowd (2055/udp)
* Start all required services and keep container running

# Example build ...

```bash
mmorrow24work@digital-twin-version-1-0:~/docker/custom-images/docker_custom_image_kathara_alpine_pc$ docker --debug build -t alpine_pc:1.0 . 
[+] Building 5.6s (8/8) FINISHED                                                                                                                                                                                                          docker:default
 => [internal] load build definition from Dockerfile                                                                                                                                                                                                0.0s
 => => transferring dockerfile: 1.53kB                                                                                                                                                                                                              0.0s
 => [internal] load metadata for docker.io/library/alpine:latest                                                                                                                                                                                    1.4s
 => [internal] load .dockerignore                                                                                                                                                                                                                   0.0s
 => => transferring context: 2B                                                                                                                                                                                                                     0.0s
 => [1/4] FROM docker.io/library/alpine:latest@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1                                                                                                                              0.8s
 => => resolve docker.io/library/alpine:latest@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1                                                                                                                              0.0s
 => => sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 9.22kB / 9.22kB                                                                                                                                                      0.0s
 => => sha256:eafc1edb577d2e9b458664a15f23ea1c370214193226069eb22921169fc7e43f 1.02kB / 1.02kB                                                                                                                                                      0.0s
 => => sha256:9234e8fb04c47cfe0f49931e4ac7eb76fa904e33b7f8576aec0501c085f02516 581B / 581B                                                                                                                                                          0.0s
 => => sha256:9824c27679d3b27c5e1cb00a73adb6f4f8d556994111c12db3c5d61a0c843df8 3.80MB / 3.80MB                                                                                                                                                      0.4s
 => => extracting sha256:9824c27679d3b27c5e1cb00a73adb6f4f8d556994111c12db3c5d61a0c843df8                                                                                                                                                           0.2s
 => [2/4] RUN apk add --no-cache     zabbix-agent     net-snmp     net-snmp-tools     iproute2-tc     softflowd     iproute2     iputils     bash     iperf3                                                                                        2.1s
 => [3/4] RUN echo -e "com2sec readonly  default         public\ngroup   myv1group v1            readonly\ngroup   myv2cgroup v2c          readonly\nview    all       included      .1\naccess  myv1group ""      any       noauth    exact  all   0.4s 
 => [4/4] RUN sed -i     -e 's/^Server=127.0.0.1/Server=192.168.10.7/'     -e 's/^Hostname=Zabbix server/Hostname=kathara-pc/'     /etc/zabbix/zabbix_agentd.conf                                                                                   0.5s 
 => exporting to image                                                                                                                                                                                                                              0.3s 
 => => exporting layers                                                                                                                                                                                                                             0.3s 
 => => writing image sha256:e0048a37dc310d206b0c25b40c2e07c6e087603acfeac77a61f268c03ba03340                                                                                                                                                        0.0s 
 => => naming to docker.io/library/alpine_pc:1.0                                                                                                                                                                                                    0.0s 

 1 warning found:
 - JSONArgsRecommended: JSON arguments recommended for CMD to prevent unintended behavior related to OS signals (line 39)
JSON arguments recommended for ENTRYPOINT/CMD to prevent unintended behavior related to OS signals
More info: https://docs.docker.com/go/dockerfile/rule/json-args-recommended/
Dockerfile:39
--------------------
  38 |     # Start all required services and keep container running
  39 | >>> CMD snmpd -f -Lo -c /etc/snmp/snmpd.conf & \
  40 | >>>     softflowd -i eth0 -n 192.168.10.6:2055 -v 5 -b -T & \
  41 | >>>     zabbix_agentd -f
  42 |     
--------------------

mmorrow24work@digital-twin-version-1-0:~/docker/custom-images/docker_custom_image_kathara_alpine_pc$ 

```

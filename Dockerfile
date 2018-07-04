FROM debian:9-slim 

MAINTAINER Bertrand Presles <bertrand@presles.fr>

RUN apt-get -y update
RUN apt-get -y install software-properties-common gnupg2
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" > /etc/apt/sources.list.d/ansible.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
RUN apt-get -y update
RUN apt-get -y install ansible openssh-client rsync
RUN ansible-galaxy install --force carlosbuenosvinos.ansistrano-deploy carlosbuenosvinos.ansistrano-rollback --roles-path=/usr/share/ansible/roles

## Ansistrano user
RUN adduser --disabled-password --gecos '' ansistrano
RUN adduser ansistrano sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

## Ansistrano folder
RUN mkdir -p /home/ansistrano/.ssh
RUN cd /home/ansistrano/.ssh/ && ssh-keygen -t rsa -b 4096 -C '' -f /home/ansistrano/.ssh/id_rsa
RUN chown ansistrano:ansistrano -Rf /home/ansistrano/
WORKDIR /home/ansistrano/

CMD [ "ansible" ]
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

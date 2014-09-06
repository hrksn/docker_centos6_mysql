FROM centos:centos6
MAINTAINER GORI

RUN echo "exclude=.cn" >> /etc/yum/pluginconf.d/fastestmirror.conf
RUN echo "include_only=.jp" >> /etc/yum/pluginconf.d/fastestmirror.conf
RUN cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

## for mysql5.5
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

RUN yum -y install passwd bind-utils bzip2 file sudo tar time traceroute unzip vim-common vim-minimal which wget telnet iputils iproute yum-utils 

RUN yum -y install openssh-server
RUN yum -y install openssh

RUN yum -y install httpd

RUN useradd devuser -m -s /bin/bash
RUN echo 'devuser:devpass' | chpasswd
RUN echo 'devuser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/devuser

## for mysql5.1
#RUN yum -y install mysql mysql-server

## for mysql5.5
RUN yum -y install --enablerepo=remi mysql mysql-server

## mysql set up
RUN echo "NETWORKING=yes" > /etc/sysconfig/network
ADD ./setup.sql ./setup.sql
RUN /etc/init.d/mysqld start & \
        sleep 10s && \
        cat setup.sql | mysql


#RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/my.cnf

EXPOSE 22 80 3306

#CMD ["/usr/bin/mysqld_safe"]
#ENTRYPOINT ["service mysqld start"]
#CMD ["service mysqld start"]

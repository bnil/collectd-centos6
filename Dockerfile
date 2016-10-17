FROM centos:6
RUN yum install -y epel-release
RUN yum groupinstall -y 'Development Tools'
RUN yum install -y wget rpmdevtools yum-utils
RUN useradd builder
ADD contrib/redhat/collectd.spec /
RUN yum-builddep  -y /collectd.spec

USER builder
WORKDIR /home/builder/
RUN rpmdev-setuptree
RUN spectool -g -R /collectd.spec
RUN QA_RPATHS=$[ 0x0001|0x0010 ] rpmbuild -bb  /collectd.spec


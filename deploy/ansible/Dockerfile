# Dockerfile for building Ansible 1.9 image for CentOS 7, with as few additional software as possible.
#
# @see https://www.reddit.com/r/ansible/comments/46jrxc/release_20_in_epel/
# @see https://bodhi.fedoraproject.org/updates/?packages=ansible
# @see http://docs.ansible.com/intro_installation.html#latest-release-via-yum
#
# [NOTE] To fix the "sudo: sorry, you must have a tty to run sudo" issue,
#        we need to patch /etc/sudoers.
#        @see http://unix.stackexchange.com/questions/122616/why-do-i-need-a-tty-to-run-sudo-if-i-can-sudo-without-a-password
#        @see https://bugzilla.redhat.com/show_bug.cgi?id=1020147
#
# Version  1.0
#


# pull base image
FROM centos:centos7

MAINTAINER phaneendra <phaneendra.krishnareddy@gmail.com>

# Install dependencies
RUN \
    echo "===> Installing EPEL..." && \
    yum -y install epel-release && \

    echo "===> Installing initscripts to emulate normal OS behavior..." && \
    yum -y install initscripts && \

    echo "===> Installing openssh..."  && \
    yum -y install sudo openssh-clients && \

    echo "===> Installing Ansible..." && \
    yum -y install ansible && \

    echo "===> Installing supervisor..."  && \
    yum -y install supervisor && \
    # mv -f /etc/supervisord.conf /etc/supervisor/supervisord.conf.org && \

    echo "===> Installing git..." && \
    yum -y install git && \

    echo "===> Removing unused YUM resources..." && \
    yum -y remove epel-release && \
    yum clean all

RUN echo "===> Disabling sudo 'requiretty' setting..." && \
    sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers  || true

# display Ansible version
RUN ansible-playbook --version

# Adding files
COPY root/supervisor/ /etc/supervisor/
COPY ./docker-entrypoint.sh /
RUN chmod 775 /docker-entrypoint.sh
WORKDIR /opt/ansible
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 22

# default command to start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

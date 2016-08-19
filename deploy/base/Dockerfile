# Base container DockerFile for setting up applications.
# Dockerfile for building Base application image for CentOS 7, with as few additional software as possible.
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
FROM centos:7

MAINTAINER phaneendra <phaneendra.krishnareddy@gmail.com>

# Install dependencies
RUN \
    echo "===> Installing EPEL..."        && \
    yum -y install epel-release           && \

    echo "===> Installing initscripts to emulate normal OS behavior..."  && \
    yum -y install initscripts && \

    echo "===> Installing openssh..."  && \
    yum -y install sudo openssh-server && \

    echo "===> Installing supervisor..."  && \
    yum -y install supervisor && \
    # mv -f /etc/supervisord.conf /etc/supervisor/supervisord.conf.org && \

    echo "===> Installing vim..."  && \
    yum install -y vim && \

    echo "===> Removing unused YUM resources..."  && \
    yum -y remove epel-release                    && \
    yum clean all

RUN echo "===> Disabling sudo 'requiretty' setting..." && \
    sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers  || true  && \

    # Various options to make SSH access easier when testing Ansible playbooks
    echo "===> Adding ssh hostkeys..." && \
    rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && \
    sed -i "s/StrictModes.*/StrictModes no/g" /etc/ssh/sshd_config && \
    sed -i -e 's/^\(UsePAM\s\+.\+\)/#\1/gi' /etc/ssh/sshd_config && \
    echo -e '\nUsePAM no' >> /etc/ssh/sshd_config && \

    # Create user - ansible - for ssh access and enable sudo operations
    # Create the home directory if it does not exist.
    # Add to wheel group to provide sudo access.
    echo "===> Creating user for ansible provisioning..." && \
    groupadd -r ansible && \
    useradd -mg ansible ansible && \
    gpasswd -a ansible wheel && \
    echo 'ansible ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers && \
    su - ansible -c "mkdir ~/.ssh" && \
    touch /home/ansible/.Xauthority && \

    # Vim configs for root user
    echo 'syntax on'      >> /root/.vimrc && \
    echo 'alias vi="vim"' >> /root/.bash_profile && \
    # Vim configs for ansible
    echo 'syntax on'      >> /home/ansible/.vimrc && \
    echo 'alias vi="vim"' >> /home/ansible/.bash_profile

# Adding files
COPY root/supervisor/ /etc/supervisor/
COPY ./docker-entrypoint.sh /
RUN chmod 775 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 22

# default command to start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

# Set up a standard volume for logs.
VOLUME ["/var/log/services"]

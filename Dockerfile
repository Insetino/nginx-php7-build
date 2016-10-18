FROM legerete/nginx-php7:1.0.0
MAINTAINER Petr Besir Horacek <petr.horacek@legerete.cz>

RUN yum install -y docker \
    btrfs-progs \
    e2fsprogs \
    e2fsprogs-extra \
    iptables \
    xfsprogs \
    xz \
    which


# set up subuid/subgid so that "--userns-remap=default" works out-of-the-box
RUN set -x \
    && groupadd dockremap \
    && useradd -g dockremap dockremap \
    && echo 'dockremap:165536:65536' >> /etc/subuid \
    && echo 'dockremap:165536:65536' >> /etc/subgid

ENV DIND_COMMIT 3b5fac462d21ca164b3778647420016315289034

RUN wget "https://raw.githubusercontent.com/docker/docker/${DIND_COMMIT}/hack/dind" -O /usr/local/bin/dind \
    && chmod +x /usr/local/bin/dind

RUN curl -s http://getcomposer.org/installer | php && mv ./composer.phar /usr/local/bin/composer    

VOLUME /var/lib/docker
EXPOSE 2375

#Start
ADD entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD []

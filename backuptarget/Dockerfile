FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends openssh-server gnupg
RUN mkdir /var/run/sshd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
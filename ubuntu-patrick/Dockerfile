FROM ubuntu:23.04

RUN apt-get update && apt-get install -y openssh-server curl
RUN useradd -ms /bin/bash -G sudo patrick
RUN mkdir -p /home/patrick/.ssh
RUN curl -o /home/patrick/.ssh/authorized_keys  https://github.com/phoward26.keys && \
chmod 0600 /home/patrick/.ssh/authorized_keys
RUN service ssh start
EXPOSE 22

# Avoid container exit.
CMD ["tail", "-f", "/dev/null"]

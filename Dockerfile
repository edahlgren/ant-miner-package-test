FROM ubuntu:16.04

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive

ADD setup.sh /setup.sh
RUN chmod 755 /setup.sh && /setup.sh

CMD ["/bin/bash"]

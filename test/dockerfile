# syntax=docker/dockerfile:1
FROM archlinux:base-devel
COPY . /myarch
COPY install /myarch/install
WORKDIR /myarch
RUN ./myarch
CMD /bin/sh



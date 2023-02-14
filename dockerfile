# syntax=docker/dockerfile:1
FROM archlinux:base-devel
COPY . /myarch
RUN myarch/myarch
CMD /bin/sh



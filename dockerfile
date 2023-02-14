# syntax=docker/dockerfile:1
FROM archlinux:latest
COPY . /myarch
RUN myarch/myarch



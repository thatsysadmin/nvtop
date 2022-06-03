FROM fedora:latest

RUN dnf update -y
COPY . /nvtop
WORKDIR /nvtop
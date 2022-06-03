FROM fedora:latest

RUN dnf update -y
RUN dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
RUN dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
RUN dnf install -y xorg-x11-drv-nvidia-cuda
RUN dnf install -y install cmake ncurses-devel

COPY . /nvtop
WORKDIR /nvtop
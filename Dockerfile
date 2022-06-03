FROM fedora:35

RUN dnf update -y
RUN dnf install -y cmake ncurses-devel wget rpm-build
RUN dnf install -y https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda-repo-fedora35-11-7-local-11.7.0_515.43.04-1.x86_64.rpm
RUN dnf install -y cuda
WORKDIR /nvtop
ENTRYPOINT bash build.sh
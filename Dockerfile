FROM fedora:35

RUN dnf update -y
RUN dnf install -y cmake ncurses-devel wget
RUN wget https://developer.download.nvidia.com/compute/cuda/11.7.0/local_installers/cuda_11.7.0_515.43.04_linux.run --progress=bar:force:noscroll -q --show-progress -O /root/cuda.run && chmod a+x /root/cuda.run
RUN /root/cuda.run --silent --toolkit --toolkitpath=/usr --no-opengl-libs --no-man-page --no-drm && rm /root/cuda.run

COPY . /nvtop
WORKDIR /nvtop
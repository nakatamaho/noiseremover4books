# build
# docker build -t denoisetest_tf .
# run
# docker run --rm -it --gpus all -v /work1/bookscan_linefix:/work/bookscan_linefix denoisetest_tf:latest

# docker pull tensorflow/tensorflow:latest-gpu-jupyter
# docker run --rm -it -d -p 8888:8888 --gpus all -v /work1/noiseremover4books/notebooks:/tf -v /work1/noiseremover4books/:/work tensorflow/tensorflow:latest-gpu-jupyter
# or
# docker run --rm -it -d -p 8888:8888 --gpus all -v /home/maho/notebooks:/tf tensorflow/tensorflow:latest-gpu-jupyter

FROM tensorflow/tensorflow:latest-devel-gpu-jupyter

#FROM nvidia/cuda:11.7.1-devel-ubuntu22.04
#FROM tensorflow/tensorflow:2.11.0rc0-gpu

#git setting
ARG GIT_EMAIL="maho.nakata@gmail.com"
ARG GIT_NAME="NAKATA Maho"

LABEL maintainer="maho.nakata@gmail.com"

ARG DEBIAN_FRONTEND=noninteractive
#RUN apt -y update
#RUN apt -y upgrade
RUN apt install -y sudo
RUN apt install -y tzdata
# set your timezone
ENV TZ Asia/Tokyo
RUN echo "${TZ}" > /etc/timezone \
  && rm /etc/localtime \
  && ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && dpkg-reconfigure -f noninteractive tzdata

RUN apt install -y python3 python3-pip
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN apt install -y build-essential gcc g++ gfortran libgl1-mesa-dev poppler-utils
RUN apt install -y git wget sudo time parallel bc openssh-server lv less
RUN apt install -y ng-common ng-cjk emacs-nox
RUN apt install libgl1-mesa-dev

RUN pip install tensorflow==2.9.2
RUN pip install keras
RUN pip install opencv-python

ARG DOCKER_UID=1000
ARG DOCKER_USER=docker
ARG DOCKER_PASSWORD=docker
RUN useradd -u $DOCKER_UID -m $DOCKER_USER --shell /bin/bash && echo "$DOCKER_USER:$DOCKER_PASSWORD" | chpasswd && echo "$DOCKER_USER ALL=(ALL) ALL" >> /etc/sudoers
ARG WORK=/home/$DOCKER_USER

USER docker
USER ${DOCKER_USER}
RUN echo "\n\
[user]\n\
        email = ${GIT_EMAIL}\n\
        name = ${GIT_NAME}\n\
" > /home/$DOCKER_USER/.gitconfig
SHELL ["/bin/bash", "-c"]

# Docker file for Neovim Go development.
#
# @author Maciej Bedra

# Base Neovim image.
FROM ubuntu:22.04

RUN --mount=type=cache,target=/var/cache/apt apt-get update && \
apt-get install -y build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev wget unzip
# Optional
# python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
ARG OPENCV_VERSION=4.7.0
WORKDIR /root/TMP
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
wget -O  opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip && \
unzip -q opencv.zip && unzip -q opencv_contrib.zip && \
rm *.zip

WORKDIR /root/TMP/build
# cmake -GNinja -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-4.7.0/modules -DWITH_GTK=ON ../opencv-4.7.0
RUN cmake -D CMAKE_INSTALL_PREFIX=/usr/local -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=ON -D BUILD_opencv_java=NO -D BUILD_opencv_python=NO -D BUILD_opencv_python2=NO -D BUILD_opencv_python3=NO -D OPENCV_GENERATE_PKGCONFIG=ON -D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib-${OPENCV_VERSION}/modules ../opencv-${OPENCV_VERSION}

RUN make -j $(nproc --all)
RUN make preinstall 
RUN make install 

WORKDIR /root
RUN rm -rf /root/TMP

# Avoid container exit.
CMD ["tail", "-f", "/dev/null"]

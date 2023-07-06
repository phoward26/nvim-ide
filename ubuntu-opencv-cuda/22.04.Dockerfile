# Docker file for Neovim Go development.
#
# @author Maciej Bedra

# Base Neovim image.
FROM nvidia/cuda:12.2.0-devel-ubuntu22.04

ARG OPENCV_VERSION=4.7.0

RUN --mount=type=cache,target=/var/cache/apt apt-get update && \
apt-get install -y build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev wget unzip
# Optional
# python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev

WORKDIR /root/TMP
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip && \
wget -O  opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip && \
unzip -q opencv.zip && unzip -q opencv_contrib.zip && \
rm *.zip

WORKDIR /root/TMP/build
# cmake -GNinja -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-4.7.0/modules -DWITH_GTK=ON ../opencv-4.7.0
RUN cmake -D CMAKE_INSTALL_PREFIX=/usr/local \
-D WITH_TBB=ON \
-D ENABLE_FAST_MATH=1 \
-D CUDA_FAST_MATH=1 \
-D WITH_CUBLAS=1 \
-D WITH_CUDA=ON \
-D BUILD_opencv_cudacodec=OFF \
-D WITH_CUDNN=OFF \
-D OPENCV_DNN_CUDA=OFF \
-D CUDA_ARCH_BIN=7.5 \
-D WITH_V4L=ON \
-D WITH_QT=OFF \
-D WITH_OPENGL=ON \
-D WITH_GSTREAMER=ON \
-D OPENCV_GENERATE_PKGCONFIG=ON \
-D OPENCV_PC_FILE_NAME=opencv.pc \
-D OPENCV_ENABLE_NONFREE=ON \
-D INSTALL_PYTHON_EXAMPLES=OFF \
-D INSTALL_C_EXAMPLES=OFF \
-D BUILD_EXAMPLES=OFF \
-D OPENCV_EXTRA_MODULES_PATH=../opencv_contrib-${OPENCV_VERSION}/modules ../opencv-${OPENCV_VERSION}

RUN make -j $(nproc --all)
RUN make preinstall 
RUN make install 

WORKDIR /root
RUN rm -rf /root/TMP

# Avoid container exit.
CMD ["tail", "-f", "/dev/null"]

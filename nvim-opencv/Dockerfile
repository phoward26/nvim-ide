# Docker file for Neovim Go development.
#
# @author Maciej Bedra

# Base Neovim image.
FROM phoward26/nvim

RUN mkdir /root/TMP && \
cd TMP && \
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.7.0.zip && \
wget -O  opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.7.0.zip && \
unzip opencv.zip && unzip opencv_contrib.zip && \
mkdir build && cd build && \
cmake -GNinja -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-4.7.0/modules -DWITH_GTK=ON ../opencv-4.7.0 && \
ninja && ninja install \
rm -rf /root/TMP

# Avoid container exit.
CMD ["tail", "-f", "/dev/null"]

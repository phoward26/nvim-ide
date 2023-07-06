# Dockerfile for basic neovim development environment
# Automatically includes support for linting and formatting of c++, lua, cmake, dockerfiles
# Uses NvChad as a basis and implements all custom extras in the lua/custom directory


# custom image of ubuntu 23.04 with opencv 4.7.0 built from scratch
FROM ubuntu:22.04
# Set image locale.
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
RUN ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime
RUN echo "$TZ" > /etc/timezone
ENV TZ=America/Chicago

# Expose some ports to host by default.
EXPOSE 8080 8081 8082 8083 8084 8085 22

# Program aruments
ARG GIT_FLOW_GITHUB='https://github.com/petervanderdoes/gitflow-avh.git'
ARG NVCHAD_GITHUB='https://github.com/NvChad/NvChad'
ARG CONFIG_GITHUB='https://github.com/phoward26/my-config-files' 
ARG NVIM_RELEASE='https://github.com/neovim/neovim/archive/refs/tags/stable.zip' 
ARG DEBIAN_FRONTEND=noninteractive  
# Update repositories and install software:
# 1. curl.
# 2. fzf for fast file search.
# 3. ripgrep for fast text occurrence search.
# 4. tree for files tree visualization.
# 5. Git.
# 6. Lazygit for Git visualization.
# 7. xclip for clipboard handling.
# 8. Python 3.
# 9. pip for Python.
# 10. NodeJS.
# 11. npm for NodeJS.
# 12. tzdata to set default container timezone.
# 13. Everything needed to install Neovim from source.
RUN --mount=type=cache,target=/var/cache/apt apt-get update && apt-get -y install curl fzf ripgrep tree git xclip python3 python3-pip python3-venv nodejs npm tzdata ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config wget zip unzip openssh-server curl

RUN useradd -ms /bin/bash -G sudo patrick
RUN mkdir -p /home/patrick/.ssh
RUN curl -o /home/patrick/.ssh/authorized_keys  https://github.com/phoward26.keys && \
chmod 0600 /home/patrick/.ssh/authorized_keys && \
chown -R patrick:patrick /home/patrick/.ssh
RUN service ssh start

# Install Neovim from source.
WORKDIR /root/TMP
RUN wget -O nvim.zip ${NVIM_RELEASE} && \
unzip -q nvim.zip && cd neovim-stable && \
make CMAKE_BUILD_TYPE=RelWithDebInfo -j $(nproc --all) && \
make install

# Install NvChad
RUN git clone ${NVCHAD_GITHUB} /home/patrick/.config/nvim && \
git clone ${CONFIG_GITHUB} /root/TMP/config && \
cp -r /root/TMP/config/nvim /home/patrick/.config && \
cp /root/TMP/config/.bashrc /home/patrick/
RUN rm -rf /root/TMP

RUN chown -R patrick:patrick /home/patrick
# Bash aliases
# COPY ./home/ /root/

# Set default location after container startup.
WORKDIR /root/workspace

# Avoid container exit.
CMD ["tail", "-f", "/dev/null"]

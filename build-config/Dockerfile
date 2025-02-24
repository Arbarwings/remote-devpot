# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/releases
# for a list of version numbers.
FROM phusion/baseimage:noble-1.0.0

# Use the closest mirrors
RUN apt-get update && apt-get install -y --no-install-recommends pipx \
    && pipx install apt-mirror-updater \
    && apt-mirror-updater --auto-change-mirror \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install locale
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ARG TZ=Europe/Amsterdam
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/"$TZ" /etc/localtime && echo "$TZ" > /etc/timezone \
    && apt-get update && apt-get install -f -y --no-install-recommends --reinstall locales && locale-gen en_US.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Update Ubuntu
RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold" \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# Install build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    build-essential \
    curl \
    git \
    nano \
    unzip \
    wget \
    zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add workspace folder
RUN mkdir /workspace && chmod 775 /workspace

# Install OH-MY-ZSH to see pretty terminal and ditch the bash
ENV ZSH=/home/.oh-my-zsh
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends zsh fonts-powerline \
    && curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh \
    && git clone https://github.com/denysdovhan/spaceship-prompt.git /home/.oh-my-zsh/themes/spaceship-prompt \
    && ln -s /home/.oh-my-zsh/themes/spaceship-prompt/spaceship.zsh-theme /home/.oh-my-zsh/themes/spaceship.zsh-theme \
    && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="spaceship"/g' /root/.zshrc \
    && sed -i 's/plugins=(git)/zstyle :omz:plugins:ssh-agent agent-forwarding yes\nplugins=(git ssh-agent)/g' /root/.zshrc \
    && echo "SPACESHIP_PROMPT_ASYNC=false" >> /root/.spaceshiprc.zsh \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install NVM
SHELL ["/bin/zsh", "-o", "pipefail", "-c"]
ENV NVM_DIR /usr/local/nvm
RUN mkdir -p "$NVM_DIR" \
    && curl --silent --location https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash \
    && source "$NVM_DIR/nvm.sh" \
    && sed -i 's/plugins=(git ssh-agent)/plugins=(git ssh-agent nvm)/g' /root/.zshrc \
    && echo "export NVM_DIR=$NVM_DIR" >> /root/.zshrc

# Install NodeJS
ARG NODE_VERSION=22
ENV NODE_VERSION ${NODE_VERSION}
SHELL ["/bin/zsh", "-o", "pipefail", "-c"]
RUN /bin/zsh -c "source $NVM_DIR/nvm.sh \
    && nvm install ${NODE_VERSION} \
    && nvm alias default ${NODE_VERSION} \
    && nvm use default \
    && mkdir /var/opt/npm-cache \
    && chown -R 1000:33 /var/opt/npm-cache \
    && npm config set cache /var/opt/npm-cache --global \
    && npm cache verify --global"   

# Install OneDrive
COPY cron/onedrive /etc/cron.hourly/onedrive
RUN wget -qO - https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_24.04/Release.key | gpg --dearmor | tee /usr/share/keyrings/obs-onedrive.gpg > /dev/null
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/obs-onedrive.gpg] https://download.opensuse.org/repositories/home:/npreining:/debian-ubuntu-onedrive/xUbuntu_24.04/ ./" | tee /etc/apt/sources.list.d/onedrive.list
RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests onedrive \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/.config/onedrive \
    && mkdir /onedrive \
    && ln -s /workspace /onedrive/Development \
    && chmod +x /etc/cron.hourly/onedrive

# Add Git global config
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL
ARG GIT_USERNAME
RUN git config --global user.name "${GIT_USER_NAME}" && git config --global user.email "${GIT_USER_EMAIL}" && git config --global core.fileMode false
RUN if [ -n "${GIT_USERNAME}" ]; then git config --global user.username "${GIT_USERNAME}"; fi

# Install NodeJS package update checker and Yarn
RUN /bin/zsh -c "source $NVM_DIR/nvm.sh \
    && npm install -g npm-check-updates"

# Install SSH key
COPY init/01_add_ssh_keys.sh /etc/my_init.d/01_add_ssh_keys.sh
RUN apt-get update && apt-get install -y --no-install-recommends \
    dos2unix \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN dos2unix /etc/my_init.d/01_add_ssh_keys.sh
RUN rm -f /etc/service/sshd/down \
    && /etc/my_init.d/00_regen_ssh_host_keys.sh \
    && chmod +x /etc/my_init.d/01_add_ssh_keys.sh

# Change the max file watch
#RUN echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf && sysctl -p

# Set new path and fix NPM
RUN echo "export PATH=$PATH" >> /root/.zshrc \
    && echo "source $NVM_DIR/nvm.sh" >> /root/.zshrc

# Add volume
VOLUME /workspace

# Set workdir
WORKDIR /workspace

# Expose used ports
EXPOSE 22

# Change default shell
SHELL ["/bin/zsh", "-c"]
RUN chsh -s /bin/zsh root

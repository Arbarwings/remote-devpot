# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/releases
# for a list of version numbers.
FROM phusion/baseimage:focal-1.0.0

# Install locale
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ARG TZ=Europe/Amsterdam
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
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
    build-essential \
    apt-transport-https \
    curl \
    zip \
    unzip \
    git \
    wget \
    nano \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Nginx
RUN add-apt-repository ppa:nginx/stable && apt-get update \
    && apt-get install -y --no-install-recommends nginx-full \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Disable services start
RUN update-rc.d -f nginx remove

# Add startup scripts for Nginx
COPY services/nginx.sh /etc/service/nginx/run
RUN chmod +x /etc/service/nginx/run

# Add workspace folder
RUN mkdir /workspace && usermod -u 1000 -d /workspace -s /bin/bash www-data && chown -R www-data:www-data /workspace && chmod 775 /workspace

# Install OH-MY-ZSH to see pretty terminal and ditch the bash
ENV ZSH=/home/.oh-my-zsh
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends zsh fonts-powerline \
    && curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh \
    && git clone https://github.com/denysdovhan/spaceship-prompt.git /home/.oh-my-zsh/themes/spaceship-prompt \
    && ln -s /home/.oh-my-zsh/themes/spaceship-prompt/spaceship.zsh-theme /home/.oh-my-zsh/themes/spaceship.zsh-theme \
    && sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="spaceship"/g' /root/.zshrc \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install NVM
SHELL ["/bin/zsh", "-o", "pipefail", "-c"]
ENV NVM_DIR /usr/local/nvm
RUN mkdir -p "$NVM_DIR" \
    && curl --silent --location https://raw.githubusercontent.com/creationix/nvm/master/install.sh | zsh \
    && source $NVM_DIR/nvm.sh \
    && sed -i 's/plugins=(git)/plugins=(git nvm)/g' /root/.zshrc \
    && echo "export NVM_DIR=$NVM_DIR" >> /root/.zshrc

# Install NodeJS
ARG NODE_VERSION=16
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

# Install SSH key
COPY init/01_add_ssh_keys.sh /etc/my_init.d/01_add_ssh_keys.sh
RUN rm -f /etc/service/sshd/down \
    && /etc/my_init.d/00_regen_ssh_host_keys.sh \
    && chmod +x /etc/my_init.d/01_add_ssh_keys.sh

# Install permissons fix
COPY init/02_fix_permissions.sh /etc/my_init.d/02_fix_permissions.sh
RUN chmod +x /etc/my_init.d/02_fix_permissions.sh

# Install OneDrive
COPY cron/onedrive /etc/cron.hourly/onedrive
RUN add-apt-repository ppa:yann1ck/onedrive && apt-get update \
    && apt-get install -y --no-install-recommends onedrive \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* \
    && mkdir -p /root/.config/onedrive \
    && mkdir /onedrive \
    && ln -s /workspace /onedrive/Development \
    && chmod +x /etc/cron.hourly/onedrive

# Add Git global config
ARG GIT_USER_NAME
ARG GIT_USER_EMAIL
RUN git config --global user.name "${GIT_USER_NAME}" && git config --global user.email "${GIT_USER_EMAIL}" && git config --global core.fileMode false

# Install NodeJS package update checker
RUN /bin/zsh -c "source $NVM_DIR/nvm.sh \
    && npm install -g npm-check-updates"

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
EXPOSE 80 443 22

# Change default shell
SHELL ["/bin/zsh", "-c"]
RUN chsh -s /bin/zsh root

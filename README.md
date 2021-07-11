<h1 align="center">
  <a href="https://github.com/Arbarwings/remote-devpot">
    <img src="https://raw.githubusercontent.com/Arbarwings/remote-devpot/master/.github/logo.svg" alt="Remote DevPot" width="250">
  </a>
  <br>Remote DevPot<br>
</h1>

<h4 align="center">For a clean and fast development environment.</h4>

<p align="center">
  <a href="https://github.com/Arbarwings/remote-devpot/actions">
    <img src="https://img.shields.io/github/workflow/status/Arbarwings/remote-devpot/Docker%20Image%20CI/master?style=flat-square"
      alt="Build Status" />
  </a>
  <a href="https://github.com/Arbarwings/remote-devpot/blob/master/LICENSE">
    <img src="https://img.shields.io/github/license/Arbarwings/remote-devpot?style=flat-square"
      alt="License" />
  </a>
</p>

<div align="center">
  <h4>
    <a href="#intro">Intro</a> |
    <a href="#requirements">Requirements</a> |
    <a href="#installation">Installation</a> |
    <a href="#usage">Usage</a>
  </h4>
</div>

## Intro

Create a clean an fast development environment that is accessible from anywhere. Projects are automatically kept backuped and in sync with your OneDrive account.

Includes:

- Ubuntu 20.04 based image
- Nginx
- SSH
- NodeJS
- OH-MY-ZSH (with spaceship theme)
- OneDrive
- GitHub auth on a public domain

## Requirements

- Docker
- Docker compose
- Traefik v2+
- GitHub account
- OneDrive account

## Installation

### Linux

```sh
# Clone the repository
$ git clone https://github.com/Arbarwings/remote-devpot.git
# Navigate to the folder
$ cd remote-devpot
# Paste your SSH keys in data/ssh/ssh-keys.pub
$ mkdir data/ssh && echo "ssh-rsa ABC..." >> data/ssh/ssh-keys.pub
# Copy the example environments
$ cp .env.example .env
# Register a new OAuth application on GitHub
# https://github.com/thomseddon/traefik-forward-auth/wiki/Provider-Setup#github
# User authorization callback URL should be: https://oauth.${DOMAIN}
# Change the environment values where needed
$ nano .env
# Build the containers
$ docker-compose build
# Start all the containers
$ docker-compose up -d
# Connect to Remote DevPot by SSH
$ ssh root@{IP} -p 1022
# Setup OneDrive and follow the instruction on screen
$ onedrive
```

### Windows

1. Install WSL 2
2. Set default version as 2
3. Install Docker Desktop
4. Install Ubuntu
5. Enable integration with Ubuntu in Docker Desktop
6. Install Github CI
7. Pull this repo
8. Use the IP settings from .env.example in .env
9. Maybe remove Thedia
10. Build Docker
11. You can open the file explorer by typing "explorer.exe ." in the Ubuntu terminal

## Usage

### Visual Studio Code Remote

- Install the SSH plugin for VSCode: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh
- Easy to use on any computer. Just connect to the Remote DevPot SSH and start developing :)
- Ports can be easily forwarded to the local machine

### Websites

- Site structure: {customer}.{DOMAIN} or {project}\_{customer}.{DOMAIN}
- Available on ports: 80 and 443

### SSH

- Add SSH keys in data/ssh/ssh-keys.pub
- Available on port: 1022

### NodeJS

- Available on port: 3000 or nodejs.{DOMAIN}

### Theia IDE

- Available on: ide.{DOMAIN}

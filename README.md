<h1 align="center">
  <a href="https://github.com/Arbarwings/remote-devpot">
    <img src="https://raw.githubusercontent.com/Arbarwings/remote-devpot/master/.github/logo.svg" alt="Remote DevPot" width="250">
  </a>
  <br>Remote DevPot<br>
</h1>

<h4 align="center">For a clean and fast development environment.</h4>

<p align="center">
  <a href="https://github.com/Arbarwings/remote-devpot/actions">
    <img src="https://img.shields.io/github/actions/workflow/status/Arbarwings/remote-devpot/dockerimage.yml?style=flat-square"
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

- Ubuntu 22.04 based image
- SSH
- NodeJS
- OH-MY-ZSH (with spaceship theme)
- OneDrive

## Requirements

- Docker
- Docker compose
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
# Change the environment values where needed
$ nano .env
# Build the containers
$ docker compose build
# Start all the containers
$ docker compose up -d
# Connect to Remote DevPot by SSH
$ ssh root@localhost -p 1022
# Setup OneDrive and follow the instruction on screen
$ onedrive
```

### Windows

1. Install Docker Desktop
2. Install Github CLI
3. Pull this repo
4. Copy .env.example to .env and fill in the values
5. Paste your SSH keys in data/ssh/ssh-keys.pub
6. Run `docker compose build`
7. Run `docker compose up -d`
8. Connect to Remote DevPot by SSH `ssh root@localhost -p 1022`
9. Setup OneDrive and follow the instruction on screen `onedrive`

## Usage

### Visual Studio Code Remote

- Install the SSH plugin for VSCode: https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh
- Easy to use on any computer. Just connect to the Remote DevPot SSH and start developing :)
- Ports can be easily forwarded to the local machine

### SSH

- Add SSH keys in data/ssh/ssh-keys.pub
- Available on port: 1022

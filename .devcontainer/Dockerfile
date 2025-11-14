FROM mcr.microsoft.com/devcontainers/base:noble

# root user settings
USER root
WORKDIR /root

## install docker cli
RUN apt-get update && \
    apt-get install -y ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" \
        > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli docker-compose-plugin

## install ruby and nodejs dependencies
RUN apt-get update && \
    # for ruby
    apt-get install -y autoconf patch build-essential rustc libssl-dev \
                            libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev \
                            libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev && \
    # for nodejs
    apt-get install -y python3 g++-12 gcc-12 make python3-pip

## install XXenv
RUN git clone --depth 1 https://github.com/rbenv/rbenv /var/lib/rbenv && \
    git clone --depth 1 https://github.com/rbenv/ruby-build.git /var/lib/rbenv/plugins/ruby-build
RUN git clone --depth 1 https://github.com/nodenv/nodenv /var/lib/nodenv && \
    git clone --depth 1 https://github.com/nodenv/node-build.git /var/lib/nodenv/plugins/node-build
RUN chown vscode:vscode -R /var/lib/rbenv /var/lib/nodenv

# vscode user settings
USER vscode
WORKDIR /home/vscode

## install languages
ENV PATH=/var/lib/rbenv/bin:/var/lib/nodenv/bin:$PATH
ENV RBENV_ROOT=/var/lib/rbenv
ENV NODENV_ROOT=/var/lib/nodenv

RUN rbenv install 3.4.7
RUN nodenv install 24.11.1

ENV PATH=/var/lib/pyenv/shims:/var/lib/rbenv/shims:/var/lib/nodenv/shims:$PATH

RUN rbenv global 3.4.7 && nodenv global 24.11.1

## install ai agent
RUN npm install -g @kilocode/cli && nodenv rehash
RUN npm install -g @anthropic-ai/claude-code && nodenv rehash

## configure docker cli
RUN echo "alias docker='sudo docker'" >> ~/.bashrc

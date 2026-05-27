FROM ghcr.io/actions/actions-runner:latest

USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    zip \
    git \
    jq \
    vim \
    build-essential \
    python3 \
    python3-pip \
    ca-certificates \
    gnupg \
    software-properties-common \
    apt-transport-https \
    lsb-release

# =========================
# Install Docker CLI
# =========================

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker.gpg && \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli

# =========================
# Install kubectl
# =========================

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# =========================
# Install Helm
# =========================

RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# =========================
# Install AWS CLI
# =========================

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip

# =========================
# Install Java 17
# =========================

RUN apt-get update && apt-get install -y openjdk-17-jdk

# =========================
# Install Maven
# =========================

RUN apt-get install -y maven

# =========================
# Install Gradle
# =========================

RUN apt-get install -y gradle

# =========================
# Install NodeJS 20
# =========================

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# =========================
# Install Mend CLI
# =========================

RUN curl https://downloads.mend.io/cli/linux_amd64/mend -o /usr/local/bin/mend && \
    chmod +x /usr/local/bin/mend

# =========================
# Cleanup
# =========================

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

USER runner

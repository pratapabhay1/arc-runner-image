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
    python3-venv \
    docker.io \
    nodejs \
    npm \
    openjdk-17-jdk \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Create Python virtual environment
RUN python3 -m venv /opt/security-tools

# Install Semgrep + Detect Secrets inside venv
RUN /opt/security-tools/bin/pip install --upgrade pip && \
    /opt/security-tools/bin/pip install semgrep detect-secrets

# Install Trivy
RUN wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | tee /usr/share/keyrings/trivy.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | tee /etc/apt/sources.list.d/trivy.list && \
    apt-get update && \
    apt-get install -y trivy

# Add venv binaries to PATH
ENV PATH="/opt/security-tools/bin:$PATH"

USER runner

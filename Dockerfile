# Base image
FROM debian:stable-slim

# Install dependencies
RUN apt update && apt install -y --no-install-recommends \
    autoconf \
    build-essential \
    ca-certificates \
    cloc \
    curl \
    fop \
    libsctp-dev \
    libssl-dev \
    libwxgtk3.2-dev \
    poppler-utils \
    python3 \
    python3-pip \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Python packages
RUN pip3 install --break-system-packages fpdf2 pymupdf

# Set working directory
WORKDIR /app

# Add user
ARG USER_ID
ARG GROUP_ID
ARG USERNAME
RUN groupadd -g ${GROUP_ID} ${USERNAME} && \
    useradd -u ${USER_ID} -g ${GROUP_ID} -m ${USERNAME} && \
    mkdir -p /app/.cache && chown -R ${USERNAME}:${USERNAME} /app

# Set the default user
USER ${USERNAME}

# Install Claude - must be installed after switching to user
RUN curl -fsSL https://claude.ai/install.sh | bash

# Add Claude to PATH
ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"

CMD ["bash"]

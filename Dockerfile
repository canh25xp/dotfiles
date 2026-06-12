FROM debian:unstable

LABEL maintainer="Ngô Văn Cảnh <nv.canh@outlook.com>"
LABEL description="canh25xp's dockerize home"

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    GIT_LFS_SKIP_SMUDGE=1

# =============================================================================
# Locale Setup and Prerequisites
# =============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    curl \
    git \
    sudo \
    ca-certificates \
    openssh-server \
    && sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8

# =============================================================================
# Create User and Setup Sudo
# =============================================================================
RUN useradd -m -s /bin/bash canh25xp \
    && usermod -aG sudo canh25xp \
    && echo 'canh25xp ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# =============================================================================
# Install Chezmoi
# =============================================================================
ARG CHEZMOI_VERSION=v2.70.5
ARG TARGETARCH=amd64

RUN curl -fsSL -o /tmp/chezmoi.deb \
    "https://github.com/twpayne/chezmoi/releases/download/${CHEZMOI_VERSION}/chezmoi_${CHEZMOI_VERSION#v}_linux_${TARGETARCH}.deb" \
    && dpkg -i /tmp/chezmoi.deb \
    && rm /tmp/chezmoi.deb

# =============================================================================
# Setup User Environment
# =============================================================================
USER canh25xp
WORKDIR /home/canh25xp

# =============================================================================
# Initialize and Apply Dotfiles
# =============================================================================
ARG DOTFILES_SHA=latest

RUN echo "dotfiles: ${DOTFILES_SHA}" \
    && chezmoi init canh25xp --depth 1 \
    && chezmoi apply --no-tty

# =============================================================================
# Install Yazi
# =============================================================================
ARG YAZI_VERSION=26.1.4

# NOTE: yazi is need to run after chezmoi init to ensure dependencies installed. So sudo is needed
RUN curl -fsSL -o /tmp/yazi.deb \
    "https://github.com/sxyazi/yazi/releases/download/v${YAZI_VERSION}/yazi-x86_64-unknown-linux-gnu.deb" \
    && sudo dpkg -i /tmp/yazi.deb \
    && rm /tmp/yazi.deb

# =============================================================================
# Install npm packages
# =============================================================================
RUN npm install -g \
    @openai/codex@latest \
    opencode-ai@latest

# =============================================================================
# Install uv
# =============================================================================
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# =============================================================================
# Bootstrap tools
# =============================================================================
# Best-effort; failures are non-fatal.
RUN nvim --headless +MasonEnsureInstall +qa 2>/dev/null || true
RUN bat cache --build 2>/dev/null || true
RUN tldr --update 2>/dev/null || true
RUN ya pkg install 2>/dev/null || true

# Default shell
CMD ["/bin/bash", "-l"]

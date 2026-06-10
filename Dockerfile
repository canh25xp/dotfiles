# My Dockerized debian:unstable home.
# Usage: docker build -t dotfiles-debian:unstable .
#        docker run -it --rm dotfiles-debian:unstable

FROM debian:unstable

LABEL maintainer="Ngô Văn Cảnh <nv.canh@outlook.com>"
LABEL description="Debian unstable with chezmoi dotfiles for canh25xp"

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# =============================================================================
# Locale Setup
# =============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    locales \
    && sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# =============================================================================
# Install Prerequisites
# =============================================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    sudo \
    ca-certificates \
    gnupg \
    age \
    && rm -rf /var/lib/apt/lists/*

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

RUN curl -fsSL -o /tmp/chezmoi_linux_amd64.deb \
    "https://github.com/twpayne/chezmoi/releases/download/${CHEZMOI_VERSION}/chezmoi_${CHEZMOI_VERSION#v}_linux_amd64.deb" \
    && dpkg -i /tmp/chezmoi_linux_amd64.deb \
    && rm /tmp/chezmoi_linux_amd64.deb

# =============================================================================
# Setup User Environment
# =============================================================================
USER canh25xp
WORKDIR /home/canh25xp

# =============================================================================
# Initialize and Apply Dotfiles
# =============================================================================
# Skip LFS files and shallow clone
ENV GIT_LFS_SKIP_SMUDGE=1

# Initialize chezmoi from GitHub
RUN chezmoi init canh25xp --depth 1

# Apply dotfiles
RUN chezmoi apply --no-tty

# =============================================================================
# Bootstrap Neovim.
# =============================================================================
RUN nvim --headless +MasonEnsureInstall +qa 2>/dev/null || true

# =============================================================================
# Build Bat Cache
# =============================================================================
RUN bat cache --build 2>/dev/null || true

# =============================================================================
# Install Yazi
# =============================================================================
ARG YAZI_VERSION=26.1.4

# NOTE: yazi is need to run after chezmoi init to ensure dependencies installed. So sudo is needed
RUN curl -fsSL -o /tmp/yazi.deb \
    "https://github.com/sxyazi/yazi/releases/download/v${YAZI_VERSION}/yazi-x86_64-unknown-linux-gnu.deb" \
    && sudo dpkg -i /tmp/yazi.deb \
    && rm /tmp/yazi.deb

RUN ya pkg install

# =============================================================================
# Cleanup
# =============================================================================
RUN rm -rf ~/.cache

# Default shell
CMD ["/bin/bash", "-l"]

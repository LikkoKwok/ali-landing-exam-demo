#!/usr/bin/env bash
# Full installer for Terraform + Alibaba Cloud CLI (aliyun)
# Safe for GitHub Codespaces / Ubuntu
# - Installs required packages
# - Installs Terraform from HashiCorp apt repo
# - Installs aliyun from direct tarball (no broken installer mv)
# - Uses sudo only where needed
# - Non-fatal by default (won't crash container startup)

set +e
export DEBIAN_FRONTEND=noninteractive

log() { echo "[setup] $*"; }

log "Starting full install..."

# -----------------------------
# 0) Basic tools
# -----------------------------
log "Installing base packages..."
sudo apt-get update -y
sudo apt-get install -y \
  ca-certificates \
  curl \
  wget \
  gnupg \
  lsb-release \
  unzip \
  jq \
  make

# -----------------------------
# 1) Terraform install
# -----------------------------
if command -v terraform >/dev/null 2>&1; then
  log "Terraform already installed: $(terraform version | head -n1)"
else
  log "Installing Terraform..."

  # Add HashiCorp GPG key
  wget -O- https://apt.releases.hashicorp.com/gpg \
    | gpg --dearmor \
    | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null

  # Add repo
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null

  sudo apt-get update -y
  sudo apt-get install -y terraform
fi

# -----------------------------
# 2) Alibaba Cloud CLI install
# -----------------------------
if command -v aliyun >/dev/null 2>&1; then
  log "aliyun already installed: $(aliyun version 2>/dev/null | head -n1)"
else
  log "Installing aliyun CLI..."

  ARCH="$(uname -m)"
  case "$ARCH" in
    x86_64) A="amd64" ;;
    aarch64|arm64) A="arm64" ;;
    *)
      log "Unsupported architecture for aliyun: $ARCH"
      A=""
      ;;
  esac

  if [ -n "$A" ]; then
    TMP_DIR="$(mktemp -d)"
    cd "$TMP_DIR" || true

    # Try latest URL first, then fallback URL
    curl -fsSL "https://aliyuncli.alicdn.com/aliyun-cli-linux-latest-${A}.tgz" -o aliyun.tgz \
      || curl -fsSL "https://aliyuncli.alicdn.com/aliyun-cli-linux-${A}.tgz" -o aliyun.tgz

    tar -xzf aliyun.tgz

    BIN_PATH="$(find "$TMP_DIR" -type f -name aliyun | head -n1)"
    if [ -n "${BIN_PATH:-}" ] && [ -f "$BIN_PATH" ]; then
      chmod +x "$BIN_PATH"
      sudo install -m 0755 "$BIN_PATH" /usr/local/bin/aliyun
      log "aliyun installed to /usr/local/bin/aliyun"
    else
      log "ERROR: aliyun binary not found after extraction"
    fi

    cd / || true
    rm -rf "$TMP_DIR" || true
  fi
fi

# -----------------------------
# 3) Verification
# -----------------------------
log "---- Version check ----"
terraform version 2>/dev/null | head -n1 || log "terraform not found"
aliyun version 2>/dev/null || log "aliyun not found"
log "Install script completed."

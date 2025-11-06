#!/bin/bash

echo "Downloading nvim appimage"
wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
echo "Extracting nvim appimage"
./nvim-linux-x86_64.appimage --appimage-extract


# Get the current working directory
CURRENT_DIR="$(pwd)"

# Construct the alias line with the current directory
ALIAS_LINE="alias nvim=${CURRENT_DIR}/squashfs-root/usr/bin/nvim"

BASHRC="$HOME/.bashrc"

# Check if the alias already exists
if ! grep -Fxq "$ALIAS_LINE" "$BASHRC"; then
    echo "" >> "$BASHRC"
    echo "$ALIAS_LINE" >> "$BASHRC"
    echo "Alias added to .bashrc"
else
    echo "Alias already exists in .bashrc"
fi

source ~/.bashrc


# Define Neovim config destination
NVIM_CONFIG_DIR="$HOME/.config/nvim"

# Clone the Neovim config if not already present
if [ ! -d "$NVIM_CONFIG_DIR" ]; then
    echo "Cloning Neovim config from mieshki/cfg..."
    git clone https://github.com/mieshki/cfg.git "$HOME/.config/tmp_cfg"
    if [ -d "$HOME/.config/tmp_cfg/nvim" ]; then
        mv "$HOME/.config/tmp_cfg/nvim" "$NVIM_CONFIG_DIR"
        rm -rf "$HOME/.config/tmp_cfg"
        echo "Neovim config installed to ~/.config/nvim"
    else
        echo "Error: 'nvim' directory not found in the cloned repository."
    fi
else
    echo "Neovim config already exists at ~/.config/nvim"
fi


# Install npm if not already installed
if ! command -v npm &> /dev/null; then
    echo "npm not found. Installing Node.js and npm..."
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt install -y nodejs npm
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y nodejs
    elif command -v pacman &> /dev/null; then
        sudo pacman -Sy nodejs npm
    else
        echo "Package manager not recognized. Please install Node.js and npm manually."
    fi
else
    echo "npm is already installed."
fi


# Run Neovim in headless mode and update none-ls.nvim using Lazy

${CURRENT_DIR}/squashfs-root/usr/bin/nvim --headless "+Lazy! update none-ls.nvim" +qa

echo "none-ls.nvim plugin updated via Lazy.nvim"


# Lazygit version to install
VERSION="0.40.2"

# Download and install lazygit
echo "Installing Lazygit version $VERSION..."

# Create a temporary directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR" || exit

# Download the binary
wget -O lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${VERSION}/lazygit_${VERSION}_Linux_x86_64.tar.gz"

# Extract and move to /usr/local/bin
tar -xzf lazygit.tar.gz
sudo mv lazygit /usr/local/bin/

# Clean up
cd ~
rm -rf "$TMP_DIR"

# Confirm installation
echo "Lazygit installed successfully!"
lazygit --version


# Install ripgrep
sudo apt update
sudo apt install -y ripgrep

# Confirm installation
if command -v rg &> /dev/null; then
    echo "ripgrep installed successfully!"
else
    echo "ripgrep installation failed."
fi


# Step 1: Install tmux plugin manager (TPM)
echo "Installing tmux plugin manager (TPM)..."
mkdir -p ~/.tmux/plugins
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "TPM already installed."
fi

# Step 2: Install Catppuccin theme for tmux
echo "Installing Catppuccin theme for tmux..."
mkdir -p ~/.config/tmux/plugins/catppuccin
if [ ! -d "$HOME/.config/tmux/plugins/catppuccin/tmux" ]; then
    git clone https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin/tmux
else
    echo "Catppuccin theme already installed."
fi

# Step 3: Apply .tmux.conf from mieshki/cfg repo
echo "Applying .tmux.conf from mieshki/cfg repo..."
tmp_dir=$(mktemp -d)
git clone https://github.com/mieshki/cfg.git "$tmp_dir"
if [ -f "$tmp_dir/tmux/.tmux.conf" ]; then
    cp "$tmp_dir/tmux/.tmux.conf" ~/.tmux.conf
    echo ".tmux.conf applied to home directory."
else
    echo "Error: .tmux.conf not found in the repository."
fi

# Cleanup temporary directory
rm -rf "$tmp_dir"

echo "Tmux setup complete. You can now start tmux and press prefix + I to install plugins."



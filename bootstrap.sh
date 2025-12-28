#!/usr/bin/env bash
set -e

echo "🚀 Setting up ZSH (pure + p10k)"

### Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "📦 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || true)"

### Packages
brew install zsh git curl wget fzf
brew install --cask font-meslo-lg-nerd-font

### Set zsh default
if ! echo "$SHELL" | grep -q zsh; then
  chsh -s "$(which zsh)"
fi

### Clone dotfiles
if [ ! -d "$HOME/.dotfiles" ]; then
  git clone https://github.com/kurnhyalcantara/dotfiles.git
fi

### Symlink
ln -sf "$HOME/.dotfiles/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$HOME/.dotfiles/zsh/p10k.zsh" "$HOME/.p10k.zsh"

### Powerlevel10k
if [ ! -d "$HOME/.config/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$HOME/.config/powerlevel10k"
fi

### Plugins
ZSH_PLUGIN_DIR="$HOME/.config/zsh/plugins"
mkdir -p "$ZSH_PLUGIN_DIR"

[ ! -d "$ZSH_PLUGIN_DIR/zsh-autosuggestions" ] &&
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_PLUGIN_DIR/zsh-autosuggestions"

[ ! -d "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting" ] &&
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting"

### iTerm2 font
defaults write com.googlecode.iterm2 "Normal Font" -string "MesloLGS-NF-Bold 13"
defaults write com.googlecode.iterm2 "Non Ascii Font" -string "MesloLGS-NF-Bold 13"
defaults write com.googlecode.iterm2 "Use Non-ASCII Font" -bool true

echo "🧩 Setting up tmux..."

### Install tmux
if ! command -v tmux >/dev/null 2>&1; then
  echo "📦 Installing tmux..."
  brew install tmux
fi

### Clone tmux config (dotfiles sudah di-clone sebelumnya)
TMUX_CONF_SRC="$HOME/.dotfiles/tmux/tmux.conf"
TMUX_CONF_DST="$HOME/.tmux.conf"

if [ -f "$TMUX_CONF_SRC" ]; then
  ln -sf "$TMUX_CONF_SRC" "$TMUX_CONF_DST"
  echo "🔗 Symlinked .tmux.conf"
else
  echo "⚠️ tmux.conf not found in dotfiles, skipping"
fi

### Install TPM (Tmux Plugin Manager)
TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
  echo "📦 Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  echo "📦 TPM already installed"
fi

echo "🔧 Setting up git config..."

GIT_CONF_SRC="$HOME/.dotfiles/git/gitconfig"
GIT_CONF_DST="$HOME/.gitconfig"

if [ -f "$GIT_CONF_SRC" ]; then
  ln -sf "$GIT_CONF_SRC" "$GIT_CONF_DST"
  echo "🔗 Symlinked .gitconfig"
else
  echo "⚠️ gitconfig not found in dotfiles, skipping"
fi

echo "🔧 Setting up dynamic git config (work/personal)..."

cp "$HOME/.dotfiles/git/gitconfig.local" "$HOME/.gitconfig.work"
cp "$HOME/.dotfiles/git/gitconfig.local" "$HOME/.gitconfig.local"
echo "🔗 Symlinked gitconfig work and local, please edit email in ~/.gitconfig.work and ~/.gitconfig.local"

echo "🧠 Setting up Neovim + LazyVim..."

### Neovim
if ! command -v nvim >/dev/null 2>&1; then
  echo "📦 Installing Neovim..."
  brew install neovim
fi

### Dependencies (recommended by LazyVim)
brew install \
  ripgrep \
  fd \
  tree-sitter \
  lazygit

### Backup existing nvim config (safety)
if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
  echo "📦 Backing up existing nvim config..."
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%s)"
fi

### Symlink LazyVim config
mkdir -p "$HOME/.config"
ln -sf "$HOME/.dotfiles/nvim" "$HOME/.config/nvim"

echo "✅ Neovim + LazyVim setup done"

echo "✅ DONE — restart terminal"

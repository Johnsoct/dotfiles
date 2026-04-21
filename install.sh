#!/bin/bash

git pull

# Mac-specific
# Mac-specific
# Mac-specific
if [ "$(uname -s)" = "Darwin" ]; then
    # Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Bash
    if [ "$(command -v bash)" != "/opt/homebrew/bin/bash" ]; then
        brew install bash
        echo /opt/homebrew/bin/bash | sudo tee -a /etc/shells
    fi

    chsh -s /opt/homebrew/bin/bash
fi

# TODO: convert into a loop via an array
# TODO: silent ln failures due to file already existing

# Symlinks
# Symlinks
# Symlinks

# NOTE: -f - remove existing destination files
# NOTE: -i - interactive prompt whether to remove destinations
# NOTE: -s - make symlinks instead of hard links

# Alacritty
rm -rf ~/.config/alacritty
ln -fs ~/dev/dotfiles/alacritty ~/.config

# Bash
ln -fs ~/dev/dotfiles/bash/.bashrc ~
ln -fs ~/dev/dotfiles/bash/.bash_aliases ~
ln -fs ~/dev/dotfiles/bash/.gitignore ~

# Fonts
if command -v apt &>/dev/null || command -v dnf &>/dev/null; then
    mkdir -p ~/.local/share/fonts
    ln -fs ~/dev/dotfiles/fontpatcher/DankMonoNerdFont-Regular.ttf ~/.local/share/fonts
    ln -fs ~/dev/dotfiles/fontpatcher/DankMonoNerdFontPlusCodicons-Regular.ttf ~/.local/share/fonts
else
    mkdir -p ~/Library/Fonts
    ln -fs ~/dev/dotfiles/fontpatcher/DankMonoNerdFont-Regular.ttf ~/Library/Fonts
    ln -fs ~/dev/dotfiles/fontpatcher/DankMonoNerdFontPlusCodicons-Regular.ttf ~/Library/Fonts
fi

# Konsole
if command -v dnf &>/dev/null; then
    mkdir -p ~/.local/share/konsole

    ln -fs ~/dev/dotfiles/konsole/zenbones_dark.colorscheme ~/.local/share/konsole
fi

# Nvim
rm -rf ~/.config/nvim
ln -fs ~/dev/dotfiles/nvim ~/.config

# TODO: Terminal
# if [ "$(uname -s)" = "Darwin" ]; then
# fi

# Vim
ln -fs ~/dev/dotfiles/vim/.vimrc ~

# Zellij
rm -rf ~/.config/zellij
ln -fs ~/dev/dotfiles/zellij ~/.config

# Additional Installs
# Additional Installs
# Additional Installs

chmod +x ./cli/cli-tool-install.sh
./cli/cli-tool-install.sh --yes -y --assume-yes

source ~/.bashrc

# Configurations
# Configurations
# Configurations

chmod +x ./git-config.sh
./git-config.sh

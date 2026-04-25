#!/bin/bash

# >/dev/null 2>&1
# Redirect the stdout to a black hole and redirect stderr to wherever stdout is going; i.e. silently discard
# > - Redirect stdout
# /dev/null - black hole
# 2> - redirect stderr (file descriptor 2)
# &1 - to wherever stdout goes (& means file descriptor 1)

run_os_specific_command_with_sudo() {
    # $@ expands each argument as a separate quoted string
    # $* expands all arguments as a single string

    if command -v apt &>/dev/null; then
        sudo apt "$@"

    elif command -v dnf &>/dev/null; then
        sudo dnf "$@"

    elif [ "$(uname -s)" = "Darwin" ]; then
        brew install "$@"

    else
        echo "Supported package manager not found"
        exit 1
    fi
}

install() {
    # $@ expands each argument as a separate quoted string
    # $* expands all arguments as a single string

    if command -v apt &>/dev/null; then
        sudo apt install "$@" -y

    elif command -v dnf &>/dev/null; then
        sudo dnf install "$@" -y

    elif [ "$(uname -s)" = "Darwin" ]; then
        brew install "$@"

    else
        echo "Supported package manager not found"
        exit 1
    fi
}

# GIT
if ! command -v git >/dev/null 2>&1; then
    install git
fi

# GitHub CLI
if ! command -v gh >/dev/null 2>&1; then
    if command -v apt >/dev/null 2>&1; then
        (type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) &&
            sudo mkdir -p -m 755 /etc/apt/keyrings &&
            out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg &&
            cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null &&
            sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
            sudo mkdir -p -m 755 /etc/apt/sources.list.d &&
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
            sudo apt update &&
            sudo apt install gh -y
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install dnf5-plugins
        sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
        sudo dnf install gh --repo gh-cli
    elif [ "$(uname -s)" = "Darwin" ]; then
        install gh
    fi
fi

# Alacritty
if ! command -v alacritty >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install --cask alacritty
    fi
fi

# BTOP
if ! command -v btop >/dev/null 2>&1; then
    install btop
fi

# Cargo (and Rust)
if ! command -v cargo >/dev/null 2>&1; then
    curl https://sh.rustup.rs -sSf | sh -- -y

    source ~/.bashrc
fi

# CMake
if ! command -v cmake >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install cmake
    fi
fi

# EZA
if ! command -v eza >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install eza
    else
        git clone https://github.com/eza-community/eza.git
        cd eza
        cargo install --path .
        cd ..
        rm -rf eza
    fi
fi

# Fastfetch
if ! command -v fastfetch >/dev/null 2>&1; then
    install fastfetch
fi

# FD
if ! command -v fd >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install fd
    else
        install fd-find
    fi
fi

# FZF
if ! command -v fzf >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install fzf
    else
        git clone https://github.com/junegunn/fzf.git
        chmod +x fzf/install
        ./fzf/install -y
        rm -rf fzf
    fi
fi

# Go
if ! command -v go --version >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install go
    fi
fi

# Hammerspoon
if ! command -v hs >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install --cask hammerspoon
    fi
fi

# Lazygit
if ! command -v lazygit >/dev/null 2>&1; then
    install lazygit
fi

# Lua
if ! command -v lua >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install lua
        # 5.1.x Required for a handful of NVIM plugins, such as luacheck
        install lua@5.1
    else
        # 5.1.x Required for a handful of NVIM plugins, such as luacheck
        curl -L -R -O https://www.lua.org/ftp/lua-5.1.5.tar.gz
        tar zxf lua-5.1.5.tar.gz
        cd lua-5.1.5
        make linux
        make test
        sudo make install
        cd ..
        rm -rf lua-5.1.5.tar.gz
        rm -rf lua-5.1.5
    fi
fi

# Luarocks
if ! command -v luarocks >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install luarocks
    else
        git clone https://github.com/luarocks/luarocks.git
        cd luarocks
        chmod +x ./configure
        ./configure --with-lua-include=/usr/local/include
        make
        sudo make install
        cd ..
        rm -rf luarocks
    fi
fi

# Image Magick
if ! command -v magick >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install imagemagick
    else
        git clone --depth 1 --branch 7.1.2-0 https://github.com/ImageMagick/ImageMagick.git ImageMagick-7.1.2
        cd ImageMagick-7.1.2
        ./configure
        make
        sudo make install
        /usr/local/bin/magick logo: logo.gif
        cd ..
        rm -rf ImageMagick-7.1.2
    fi
fi

# NVIM
if ! command -v nvim >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install neovim
    else
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo rm -rf /opt/nvim-linux-x86_64
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
        rm -rf nvim-linux-x86_64.tar.gz
    fi
fi

# NVM
if ! command -v nvm >/dev/null 2>&1; then
    # https://github.com/nvm-sh/nvm#installing-and-updating
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
    export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
fi

# Python
if ! command -v python3 >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install python@3.14
    fi
fi

# PIP
if ! command -v python3 -m pip --version >/dev/null 2>&1; then
    python ../python/get-pip.py
fi

# PNPM
if ! command -v pnpm >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install pnpm

        # Make pnpm available in the current shell
        source ~/.bashrc
    else
        # Uninstall
        rm -rf "$PNPM_HOME"
        npm -rm -g pnpm

        # Install
        curl -fsSL https://get.pnpm.io/install.sh | sh -

        # Make pnpm available in the current shell
        source ~/.bashrc

        pnpm setup
        corepack enable
        corepack prepare pnpm@latest --activate
    fi

    # Install global packages
    ./node/global-packages.sh
fi

# PYTEST
if ! command -v pytest >/dev/null 2>&1; then
    pip install pytest
fi

# VIM Enhanced
if ! command -v vim >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install vim
    else
        install vim-enhanced
    fi
fi

# VS Code
if ! command -v code >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install --cask visual-studio-code
    fi
fi

# Zellij
if ! command -v zellij >/dev/null 2>&1; then
    cargo install --locked zellij
fi

# Zoxide
if ! command -v zoxide >/dev/null 2>&1; then
    if [ "$(uname -s)" = "Darwin" ]; then
        install zoxide
    else
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    fi
fi

# Delete any unnecessary packages
run_os_specific_command_with_sudo autoremove

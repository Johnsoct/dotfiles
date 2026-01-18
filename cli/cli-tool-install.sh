# TODO: check for `uname -a` to determine whether linux distro
# is debian or fedora and install via apt/dnf

# GIT
sudo dnf install git

# EZA
if ! command -v eza >/dev/null 2>&1; then
    git clone git@github.com:eza-community/eza.git
    cd eza
    cargo install --path .
    cd ..
    rm -rf eza
fi

# Fastfetch
if ! command -v fastfetch >/dev/null 2>&1; then
    sudo dnf install fastfetch
fi

# FD
if ! command -v fd >/dev/null 2>&1; then
    sudo dnf install fd-find
fi

# FZF
if ! command -v fzf >/dev/null 2>&1; then
    git clone git@github.com:junegunn/fzf.git
    chmod +x fzf/install
    ./install
    rm -rf fzf
fi

# Lazygit
if ! command -v lazygit >/dev/null 2>&1; then
    sudo dnf install lazygit
fi

# Lua
if ! command -v lua >/dev/null 2>&1; then
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

# Luarocks
if ! command -v luarocks >/dev/null 2>&1; then
    git clone git@github.com:luarocks/luarocks.git
    cd luarocks
    chmod +x ./configure
    ./configure --with-lua-include=/usr/local/include
    make
    sudo make install
    cd ..
    rm -rf luarocks
fi

# Image Magick
if ! command -v magick >/dev/null 2>&1; then
    git clone --depth 1 --branch 7.1.2-0 git@github.com:ImageMagick/ImageMagick.git ImageMagick-7.1.2
    cd ImageMagick-7.1.2
    ./configure
    make
    sudo make install
    /usr/local/bin/magick logo: logo.gif
    cd ..
    rm -rf ImageMagick-7.1.2
fi

# NVIM
if ! command -v nvim >/dev/null 2>&1; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    rm -rf nvim-linux-x86_64.tar.gz
fi

# PIP
if ! command -v pip >/dev/null 2>&1; then
    sudo dnf install pip -y
fi

# PNPM
if ! command -v pnpm >/dev/null 2>&1; then
    curl -fsSL https://get.pnpm.io/install.sh | sh -
    corepack enable
    corepack prepare pnpm@latest --activate
    pnpm setup
fi

# PYTEST
if ! command -v pip >/dev/null 2>&1; then
    pip install pytest
fi

# VIM Enhanced
if ! command -v vim >/dev/null 2>&1; then
    sudo dnf install vim-enhanced
fi

# Zioxide
if ! command -v z >/dev/null 2>&1; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

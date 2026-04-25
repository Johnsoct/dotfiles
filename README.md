# Dotfiles

Commonly used packages, configuration files, and programs

## Contents

- alacritty
- bash
- cli tools
    - Git
    - GitHub CLI
    - Alacritty
    - Btop
    - Cargo (and rustup)
    - CMake
    - Eza
    - Fastfetch
    - FD (find)
    - FZF
    - Go
    - Hammerspoon
    - Lazygit
    - Lua@latest
    - Lua@5.1
    - Luarocks
    - Image Magick
    - Neovim
    - NVM (node version manager)
    - Python
    - Pip
    - Pnpm
    - Pytest
    - Vim enhanced
    - VS Code
    - Zellij
    - Zoxide
- eslint
- fontpatcher
    - Standard fonts
    - Nerd font alternatives
    - Fontpatcher CLI
- hammerspoon
- Konsole (Fedora)
- node packages
- nvim
- python pip installer
- stylelint
- terminal (mac osx)
- tsconfig
- vim
- vite
- zellij
- .gitignore

## Install

### Steps

`install.sh` installs Homebrew and Bash for Mac OSX, creates all the necessary symlinks, copies fonts to the user's fonts, and triggers `cli-tool-install.sh`

`cli-tool-install.sh` installs all the CLI tools listed above.

From within this directory, run in your terminal of choice:

1. `./install.sh`

### Mac specific steps

1. Configure Terminal.app to trigger "Alt" for the "Option" key (https://superuser.com/questions/1038947/using-the-option-key-properly-on-mac-terminal)

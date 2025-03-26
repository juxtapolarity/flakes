{ config, pkgs, ... }:

let
  dotfilesPath = "/home/jux/.config/dotfiles";
in {
  home.username = "jux";
  home.homeDirectory = "/home/jux";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    docker
    feh
    flameshot
    fzf
    git
    i3
    polybar
    mpv
    neovim
    obsidian
    oh-my-posh
    ncspot
    nsxiv
    rofi
    tmux
    vim
    wezterm
    zsh
    zsh-autosuggestions
    zsh-history-substring-search
    zsh-syntax-highlighting
    zoxide
  ];

  home.file = {
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/zsh/.zshrc";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim";
    ".config/mpv".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/mpv";
    ".config/polybar".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/polybar";
    ".tmux".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/tmux";
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/tmux/.tmux.conf";
    ".config/i3".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/i3";
    ".config/.poshthemes".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/oh-my-posh";
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/rofi";
    ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/wezterm/.wezterm.lua";
  };

  programs.home-manager.enable = true;
}


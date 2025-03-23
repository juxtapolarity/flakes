{ config, pkgs, ... }:

let
  dotfilesPath = "/home/jux/.config/dotfiles";
in {
  home.username = "jux";
  home.homeDirectory = "/home/jux";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    fzf
    neovim
    tmux
    docker
    ncspot
    zsh
    i3
    oh-my-posh
    mpv
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
  };

  programs.home-manager.enable = true;
}


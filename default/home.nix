{ config, pkgs, ... }:

let
  dotfilesPath = "/home/jux/.config/dotfiles";
in {
  home.username = "jux";
  home.homeDirectory = "/home/jux";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    appimage-run
    cmake
    docker
    feh
    flameshot
    fzf
    gcc
    git
    i3
    polybar
    mpv
    neovim
    obsidian
    oh-my-posh
    ncspot
    nerd-fonts.fira-code
    nodejs
    nsxiv
    picom
    protonup
    rofi
    tmux
    unzip
    vim
    wezterm
    xclip
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
    ".config/picom".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/picom/";
    ".config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh".source =
      "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
    ".config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh".source =
      "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
    ".config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh".source =
      "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh";

    # App images
    ".local/bin/zen".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/appimages/zen-x86_64.AppImage";
    ".config/autostart/zen.desktop".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/applications/zen.desktop";
    ".local/share/applications/zen.desktop".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/applications/zen.desktop";
  };

  programs.home-manager.enable = true;
}


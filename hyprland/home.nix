{ config, pkgs, ... }:

let
  dotfilesPath = "/home/jux/.config/dotfiles";
in {
  home.username = "jux";
  home.homeDirectory = "/home/jux";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    appimage-run
    ardour
    aria2
    btop
    cmake
    docker
    dualsensectl
    feh
    ffmpeg
    firefox
    flameshot
    flatpak
    fzf
    gamescope
    gcc
    git
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    i3
    polybar
    micromamba
    motrix
    mpv
    ncspot
    neovim
    nerd-fonts.fira-code
    nodejs
    nsxiv
    obsidian
    oh-my-posh
    persepolis
    picom
    protonup
    python312Packages.aria2p
    rofi
    tmux
    transmission_4
    unzip
    uv
    vim
    wezterm
    xclip
    yt-dlp
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

    # -------------------------------------------------------------------------
    # Shell scripts for polybar (controller battery + connection)
    # -------------------------------------------------------------------------

    # Dualsense controller
    # ".config/polybar/scripts/dualsense.sh" = {
    #   source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/polybar/scripts/dualsense.sh";
    #   executable = true;
    # };

    # Google stadia controller
    # ".config/polybar/scripts/stadia.sh" = {
    #   source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/polybar/scripts/stadia.sh";
    #   executable = true;
    # };

    # -------------------------------------------------------------------------
    # App images
    # -------------------------------------------------------------------------
    # ".local/bin/zen".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/share/appimages/zen-x86_64.AppImage";
    # ".config/autostart/zen.desktop".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/applications/zen.desktop";
    # ".local/share/applications/zen.desktop".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/applications/zen.desktop";

    # -------------------------------------------------------------------------
    # Flatpak
    # -------------------------------------------------------------------------
    ".local/share/applications/zen.desktop".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/applications/zen.desktop";

  };

  programs.home-manager.enable = true;
}


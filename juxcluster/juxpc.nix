{ config, pkgs, ... }:

let
  dotfilesPath = "${config.home.homeDirectory}/.config/dotfiles";
in
{
  imports = [
    ./juxshared.nix
  ];

  home.packages = with pkgs; [
    wineWowPackages.stable
    winetricks
    cabextract
    corefonts
    alsa-utils
    appimage-run
    ardour
    aria2
    bazecor
    bitwarden-cli
    btop
    carla
    cmake
    docker
    dualsensectl
    feh
    xwinwrap
    ffmpeg
    firefox
    firejail
    flameshot
    flatpak
    gamescope
    gcc
    github-copilot-cli
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gthumb
    i3
    imagemagick
    jack2
    jellyfin
    kitty
    localsend
    losslesscut-bin
    motrix
    mpv
    ncspot
    nerd-fonts.fira-code
    nodejs
    nsxiv
    obsidian
    persepolis
    picom
    polybar
    protonup-ng
    python312Packages.aria2p
    qjackctl
    reaper
    rofi
    samba
    sfizz
    decent-sampler
    telegram-desktop
    transmission_4
    wezterm
    yabridge
    yabridgectl
    yazi
    yt-dlp
  ];

  home.file = {
    ".config/mpv".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/mpv";

    ".config/polybar".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/polybar";

    ".config/i3".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/i3";

    ".config/rofi".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/rofi";

    ".wezterm.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/wezterm/.wezterm.lua";

    ".config/picom".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/picom";

    ".local/share/applications/zen.desktop".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/applications/zen.desktop";
  };
}

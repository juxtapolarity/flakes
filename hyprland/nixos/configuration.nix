{ config, lib, pkgs, modulesPath, ... }: {

  nixpkgs.config.allowUnfree = true;

  # Bootloader setup
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 20;

  # Hyprland (Wayland) setup
  programs.hyprland.enable = true;

  # Input and portal config
  services.mullvad-vpn.enable = true;
  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Flatpak support
  services.flatpak.enable = true;

  # NVIDIA proprietary driver setup
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics.enable32Bit = true;
  hardware.graphics.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    config.boot.kernelPackages.nvidiaPackages.stable.settings
    config.boot.kernelPackages.nvidiaPackages.stable.bin
    cudatoolkit
    steam-run
    mangohud
    vulkan-tools
  ];

  programs.zsh.enable = true;

  system.stateVersion = "24.11";
}


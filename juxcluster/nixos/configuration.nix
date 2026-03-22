{ config, lib, pkgs, modulesPath, ... }: {

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  # ---------------------------------------------------------------------------
  # Bootloader setup
  # ---------------------------------------------------------------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 20;

  # ---------------------------------------------------------------------------
  # Networking
  # ---------------------------------------------------------------------------
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # ---------------------------------------------------------------------------
  # Firmware
  # ---------------------------------------------------------------------------
  hardware.enableRedistributableFirmware = true;

  # ---------------------------------------------------------------------------
  # Shell
  # ---------------------------------------------------------------------------
  programs.zsh.enable = true;

  # ---------------------------------------------------------------------------
  # Optional timezone/locale
  # ---------------------------------------------------------------------------
  # time.timeZone = "Europe/Copenhagen";
  # i18n.defaultLocale = "en_US.UTF-8";

  # ---------------------------------------------------------------------------
  # System version
  # ---------------------------------------------------------------------------
  system.stateVersion = "25.05";
}

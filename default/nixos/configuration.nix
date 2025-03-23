{ config, lib, pkgs, modulesPath, ... }: {

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Enable the GNOME Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Optional locale/timezone/etc (uncomment and adjust if you want)
  # time.timeZone = "Europe/Copenhagen";
  # i18n.defaultLocale = "en_US.UTF-8";

  # environment.systemPackages = with pkgs; [
  #   vim
  # ];

  system.stateVersion = "24.11";
}


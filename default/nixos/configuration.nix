{ config, lib, pkgs, modulesPath, ... }: {

  nixpkgs.config.allowUnfree = true;

  # Bootloader setup (already good!)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 20;

  # NVIDIA proprietary driver setup
  # services.xserver.enable = true;
  # services.xserver.videoDrivers = [ "nvidia" ];

  services.xserver = {
    enable = true;
    layout = "dk";
    videoDrivers = [ "nvidia" ];
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    windowManager.i3.enable = true;
  };


  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    open = false; # Use the proprietary (closed-source) driver
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Optional: Vulkan support and 32-bit compatibility (good for gaming like Steam/Proton)
  hardware.graphics.enable = true;

  # GNOME desktop environment
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.windowManager.i3.enable = true;

  # Add some GPU tools and CUDA
  # environment.systemPackages = with pkgs; [
  #   # nvidia-settings
  #   nvidia-smi
  #   cudatoolkit
  # ];
  environment.systemPackages = with pkgs; [
    config.boot.kernelPackages.nvidiaPackages.stable.settings
    config.boot.kernelPackages.nvidiaPackages.stable.bin
    cudatoolkit
  ];

  # Shell
  programs.zsh.enable = true;

  # Optional timezone/locale
  # time.timeZone = "Europe/Copenhagen";
  # i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "24.11";
}


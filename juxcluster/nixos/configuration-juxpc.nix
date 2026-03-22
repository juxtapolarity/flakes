{ config, lib, pkgs, modulesPath, ... }: {

  # ---------------------------------------------------------------------------
  # X11 and Desktop setup
  # ---------------------------------------------------------------------------
  services.xserver = {
    enable = true;
    xkb.layout = "dk";
    videoDrivers = [ "nvidia" ];
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    windowManager.i3.enable = true;
    displayManager.setupCommands = ''
      xset s off
      xset s noblank
      xset -dpms
    '';
  };

  # ---------------------------------------------------------------------------
  # Flatpak system integration
  # ---------------------------------------------------------------------------
  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # ---------------------------------------------------------------------------
  # VPN
  # ---------------------------------------------------------------------------
  services.mullvad-vpn.enable = true;

  # ---------------------------------------------------------------------------
  # Tailscale
  # ---------------------------------------------------------------------------
  services.tailscale.enable = true;

  # ---------------------------------------------------------------------------
  # Actual budget
  # ---------------------------------------------------------------------------
  services.actual.enable = true;

  # ---------------------------------------------------------------------------
  # Networking
  # ---------------------------------------------------------------------------
  networking.firewall = {
    allowedTCPPorts = [ 8096 8920 ];
    allowedUDPPorts = [ 1900 7359 ];
  };

  # ---------------------------------------------------------------------------
  # Wifi / bluetooth
  # ---------------------------------------------------------------------------
  users.users.jux.extraGroups = [ "wheel" "audio" "networkmanager" ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # ---------------------------------------------------------------------------
  # Wine
  # ---------------------------------------------------------------------------
  boot.binfmt.emulatedSystems = [ "i686-linux" ];

  # ---------------------------------------------------------------------------
  # Audio
  # ---------------------------------------------------------------------------
  security.pam.loginLimits = [
    {
      domain = "@audio";
      type = "soft";
      item = "memlock";
      value = "unlimited";
    }
    {
      domain = "@audio";
      type = "hard";
      item = "memlock";
      value = "unlimited";
    }
    {
      domain = "@audio";
      type = "soft";
      item = "rtprio";
      value = "99";
    }
    {
      domain = "@audio";
      type = "hard";
      item = "rtprio";
      value = "99";
    }
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  security.rtkit.enable = true;

  environment.variables.PIPEWIRE_LATENCY = "64/48000";

  # ---------------------------------------------------------------------------
  # Firejail
  # ---------------------------------------------------------------------------
  programs.firejail.enable = true;

  # ---------------------------------------------------------------------------
  # NVIDIA
  # ---------------------------------------------------------------------------
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics.enable32Bit = true;
  hardware.graphics.enable = true;

  # ---------------------------------------------------------------------------
  # Steam
  # ---------------------------------------------------------------------------
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  hardware.steam-hardware.enable = true;

  # ---------------------------------------------------------------------------
  # System packages
  # ---------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    config.boot.kernelPackages.nvidiaPackages.stable.settings
    config.boot.kernelPackages.nvidiaPackages.stable.bin
    cudatoolkit
    steam-run
    mangohud
    vulkan-tools
    wineWowPackages.full
    winetricks
    icu
    dotnetCorePackages.runtime_8_0
  ];
}

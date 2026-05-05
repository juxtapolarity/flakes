{ config, lib, pkgs, modulesPath, ... }: {

  # ---------------------------------------------------------------------------
  # Bootloader mount point
  # ---------------------------------------------------------------------------
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Ensure GPU can wake up again, so we don't lose the display connection
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

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

    # Set DP-4 (PC monitor) as primary, disable HDMI-0 (TV) by default.
    # The TV can still be enabled at runtime via xrandr.
    xrandrHeads = [
      { output = "DP-4"; primary = true; }
      { output = "HDMI-0"; monitorConfig = ''Option "Enable" "false"''; }
    ];
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
  # Networking
  # ---------------------------------------------------------------------------
  networking.firewall = {
    allowedTCPPorts = [ 8096 8920 ];
    allowedUDPPorts = [ 1900 7359 ];
  };

  # ---------------------------------------------------------------------------
  # Wifi / bluetooth
  # ---------------------------------------------------------------------------
  users.users.jux.extraGroups = [ "wheel" "audio" "networkmanager" "lpadmin" "dialout" ];
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
    powerManagement.enable = false;
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
  # Sunshine (game streaming)
  # ---------------------------------------------------------------------------
  services.sunshine = {
    enable = true;
    autoStart = true;
    openFirewall = true;

    # Leave this OFF on juxpc for now, since you use i3/X11.
    # capSysAdmin = true;  # Wayland only
  };

  # Optional but nice for game streaming
  programs.gamemode.enable = true;

  # ---------------------------------------------------------------------------
  # Dygma keyboard udev rules (for Bazecor)
  # ---------------------------------------------------------------------------
  services.udev.extraRules = ''
    # Dygma Raise
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2200", MODE="0660", TAG+="uaccess"
    # bootloader mode
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="2201", MODE="0660", TAG+="uaccess"

    # Dygma USB Keyboards Vendor ID
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="35ef", MODE="0660", TAG+="uaccess"
    # bootloader mode
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="35ef", MODE="0660", TAG+="uaccess"

    # Dygma HID Keyboards Vendor ID
    KERNEL=="hidraw*", ATTRS{idVendor}=="35ef", MODE="0660", TAG+="uaccess"
    # bootloader mode
    KERNEL=="hidraw*", ATTRS{idVendor}=="35ef", MODE="0660", TAG+="uaccess"
  '';

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

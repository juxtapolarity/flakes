{ config, lib, pkgs, modulesPath, ... }: {

  nixpkgs.config.allowUnfree = true;

  # Bootloader setup (already good!)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 20;

  # X11 and Desktop setup
  services.xserver = {
    enable = true;
    xkb.layout = "dk";
    videoDrivers = [ "nvidia" ];
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    windowManager.i3.enable = true;
    displayManager.setupCommands = ''
      xset s off            # Disable screensaver
      xset s noblank        # Don't blank the video device
      xset -dpms            # Disable DPMS (Energy Star features)
    '';
  };

  # Flatpak system integration
  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # VPN
  services.mullvad-vpn.enable = true;

  # ---------------------------------------------------------------------------
  # Networking
  # ---------------------------------------------------------------------------
  networking.firewall = {
      enable = true;
      # Jellyfin
      allowedTCPPorts = [ 8096 8920 ];   # 8096 http, 8920 https (future-proof)
      allowedUDPPorts = [ 1900 7359 ];   # SSDP + client discovery (nice to have)
    };

  # ---------------------------------------------------------------------------
  # Wine
  # ---------------------------------------------------------------------------

  # Optional: enable 32-bit support
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

  users.users.jux.extraGroups = [ "audio" ];

  ## PipeWire (simple, revision-agnostic)
  services.pipewire = {
    enable = true;
    alsa.enable  = true;
    pulse.enable = true;
    jack.enable  = true;
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

  # NVIDIA proprietary driver setup
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaSettings = true;
    open = false; # Use the proprietary (closed-source) driver
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # OpenGL 32-bit support (needed for Steam and many games)
  # hardware.opengl.driSupport = true;
  # hardware.opengl.driSupport32Bit = true;
  hardware.graphics.enable32Bit = true;

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # optional
    dedicatedServer.openFirewall = true; # optional
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
    steam-run # Optional but useful for compatibility
    mangohud   # Optional FPS overlay
    vulkan-tools
    wineWowPackages.full
    winetricks
    icu
    pkgs.dotnetCorePackages.runtime_8_0
  ];

  # Shell
  programs.zsh.enable = true;

  # Optional timezone/locale
  # time.timeZone = "Europe/Copenhagen";
  # i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "24.11";
}


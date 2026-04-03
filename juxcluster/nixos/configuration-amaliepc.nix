{ config, lib, pkgs, modulesPath, username, ... }: {

  # ---------------------------------------------------------------------------
  # Bootloader mount point
  # ---------------------------------------------------------------------------
  boot.loader.efi.efiSysMountPoint = "/boot";

  # ---------------------------------------------------------------------------
  # X11 and Desktop setup
  # ---------------------------------------------------------------------------
  services.xserver = {
    enable = true;
    xkb.layout = "dk";
    libinput.enable = true;
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # ---------------------------------------------------------------------------
  # Tailscale
  # ---------------------------------------------------------------------------
  services.tailscale.enable = true;

  # ---------------------------------------------------------------------------
  # Wifi / bluetooth
  # ---------------------------------------------------------------------------
  users.users.${username}.extraGroups = [ "wheel" "networkmanager" "lpadmin" ];
  hardware.bluetooth.enable = true;

  # ---------------------------------------------------------------------------
  # Audio
  # ---------------------------------------------------------------------------
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  security.rtkit.enable = true;

  # ---------------------------------------------------------------------------
  # Printing
  # ---------------------------------------------------------------------------
  services.printing.enable = true;

  # ---------------------------------------------------------------------------
  # System packages
  # ---------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
  ];
}

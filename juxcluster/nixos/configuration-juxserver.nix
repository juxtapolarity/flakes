{ config, lib, pkgs, modulesPath, ... }: {

  # ---------------------------------------------------------------------------
  # Bootloader mount point
  # ---------------------------------------------------------------------------
  boot.loader.efi.efiSysMountPoint = "/boot";

  # ---------------------------------------------------------------------------
  # Tailscale
  # ---------------------------------------------------------------------------
  services.tailscale.enable = true;

  # ---------------------------------------------------------------------------
  # Actual budget
  # ---------------------------------------------------------------------------
  services.actual.enable = true;

    # ---------------------------------------------------------------------------
    # Home Assistant
    # ---------------------------------------------------------------------------
    services.home-assistant = {
      enable = true;
  
      config = {
        homeassistant = {
          name = "juxserver";
          unit_system = "metric";
          time_zone = "Europe/Copenhagen";
  
          # helpful when behind Tailscale HTTPS
          external_url = "https://nixos.tail3aa6f7.ts.net:8443";
        };
  
        default_config = {};
  
        http = {
          use_x_forwarded_for = true;
          trusted_proxies = [
            "127.0.0.1"
            "::1"
          ];
        };
      };
    };

  # ---------------------------------------------------------------------------
  # SSH
  # ---------------------------------------------------------------------------
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  # ---------------------------------------------------------------------------
  # Networking
  # ---------------------------------------------------------------------------
  networking.firewall = {
    allowedTCPPorts = [ 22 2183 ];
  };

  # ---------------------------------------------------------------------------
  # Wifi / bluetooth
  # ---------------------------------------------------------------------------
  users.users.jux.extraGroups = [ "wheel" "networkmanager" "docker" ];
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # ---------------------------------------------------------------------------
  # Docker
  # ---------------------------------------------------------------------------
  virtualisation.docker.enable = true;

  # ---------------------------------------------------------------------------
  # Prevent system sleep / suspend
  # ---------------------------------------------------------------------------
  systemd.sleep.settings = {
    Sleep = {
      AllowSuspend = false;
      AllowHibernation = false;
      AllowSuspendThenHibernate = false;
      AllowHybridSleep = false;
    };
  };

  # ---------------------------------------------------------------------------
  # Prevent GNOME / logind power actions
  # ---------------------------------------------------------------------------
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandlePowerKey = "ignore";
    HandleSuspendKey = "ignore";
    HandleHibernateKey = "ignore";
  };

  # ---------------------------------------------------------------------------
  # System packages
  # ---------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    git
    tmux
    neovim
    btop
  ];
}

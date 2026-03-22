{ config, lib, pkgs, modulesPath, ... }: {

  # ---------------------------------------------------------------------------
  # Tailscale
  # ---------------------------------------------------------------------------
  services.tailscale.enable = true;

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
    allowedTCPPorts = [ 22 ];
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
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
  '';

  # Prevent GNOME power management from suspending
  services.logind = {
    lidSwitch = "ignore";
    powerKey = "ignore";
    suspendKey = "ignore";
    hibernateKey = "ignore";
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

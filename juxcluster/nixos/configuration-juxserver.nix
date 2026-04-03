{ config, lib, pkgs, modulesPath, ... }: {

  # ---------------------------------------------------------------------------
  # Bootloader mount point
  # ---------------------------------------------------------------------------
  boot.loader.efi.efiSysMountPoint = "/boot";

  # ---------------------------------------------------------------------------
  # External drives
  # ---------------------------------------------------------------------------
  fileSystems."/mnt/media" = {
    device = "/dev/disk/by-uuid/8f27f9eb-aa9c-40e7-beec-bd9e4610c5ce";
    fsType = "ext4";
    options = [ "nofail" "noatime" "commit=600" ];
  };

  # ---------------------------------------------------------------------------
  # Tailscale
  # ---------------------------------------------------------------------------
  services.tailscale.enable = true;

  # ---------------------------------------------------------------------------
  # Actual budget
  # ---------------------------------------------------------------------------
  services.actual.enable = true;

  # ---------------------------------------------------------------------------
  # Uptime kuma
  # ---------------------------------------------------------------------------
  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT = "3001";
    };
  };

  # ---------------------------------------------------------------------------
  # Beszel
  # ---------------------------------------------------------------------------
  services.beszel.hub = {
    enable = true;
    port = 8090;
  };

  services.beszel.agent = {
    enable = true;
    environmentFile = "/etc/beszel-agent.env";
  };

  # ---------------------------------------------------------------------------
  # Homepage Dashboard
  # ---------------------------------------------------------------------------
  services.homepage-dashboard = {
    enable = true;
    allowedHosts = "localhost:8082,127.0.0.1:8082,juxserver.tail3aa6f7.ts.net:8082";
  
    settings = {
      title = "juxserver";
    };
  
    services = [
      {
        "Hosted Services" = [
          {
            "Actual Budget" = {
              href = "https://juxserver.tail3aa6f7.ts.net:3000";
              description = "Budget";
            };
          }
          {
            "Uptime Kuma" = {
              href = "https://juxserver.tail3aa6f7.ts.net:3001";
              description = "Service monitoring";
            };
          }
          {
            "Beszel" = {
              href = "https://juxserver.tail3aa6f7.ts.net:8090";
              description = "Server monitoring";
            };
          }
          {
            "Immich" = {
              href = "https://juxserver.tail3aa6f7.ts.net";
              description = "Photos";
            };
          }
          {
            "Home Assistant" = {
              href = "https://juxserver.tail3aa6f7.ts.net:8443";
              description = "Smart home";
            };
          }
        ];
      }
    ];
  };

  # ---------------------------------------------------------------------------
  # Immich
  # ---------------------------------------------------------------------------
  services.immich = {
    enable = true;
    host = "127.0.0.1";
    port = 2283;
    mediaLocation = "/mnt/media/immich";
  };

  # ---------------------------------------------------------------------------
  # Ensure Immich media permissions on external drive
  # ---------------------------------------------------------------------------
  systemd.services.immich-media-perms = {
    description = "Fix ownership for Immich media directory";
    wantedBy = [ "multi-user.target" ];
    after = [ "mnt-media.mount" ];
    requires = [ "mnt-media.mount" ];
    before = [ "immich-server.service" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.coreutils}/bin/mkdir -p /mnt/media/immich
        ${pkgs.coreutils}/bin/chown -R immich:immich /mnt/media/immich
        ${pkgs.coreutils}/bin/chmod 755 /mnt/media/immich
      '';
    };
  };

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

  # Enable matter-server
  services.matter-server.enable = true;

  # ---------------------------------------------------------------------------
  # Mosquitto (needed by frigate)
  # ---------------------------------------------------------------------------
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        port = 1883;
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
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
  # Printing
  # ---------------------------------------------------------------------------
  services.printing = {
    browsing = true;
    defaultShared = true;
    listenAddresses = [ "*:631" ];
    allowFrom = [ "192.168.1.0/24" "localhost" ];
    webInterface = true;
  };

  # ---------------------------------------------------------------------------
  # Networking
  # ---------------------------------------------------------------------------
  networking.firewall = {
    allowedTCPPorts = [ 22 631 2183 ];
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
    homepage-dashboard
  ];
}

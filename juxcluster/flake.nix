{
  description = "NixOS + Home Manager flake for juxpc and juxserver";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "jux";
      pkgs = import nixpkgs {
        inherit system;
      };

      mkHost =
        {
          hostname,
          hardwareConfig,
          hostConfig,
          homeConfig,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          modules = [
            ./nixos/configuration.nix
            hostConfig
            hardwareConfig
            home-manager.nixosModules.home-manager
            {
              networking.hostName = hostname;

              users.users.${username} = {
                isNormalUser = true;
                # extraGroups = [ "wheel" "networkmanager" ];
                shell = pkgs.zsh;
              };

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${username} = import homeConfig;

              nix.settings.experimental-features = [ "nix-command" "flakes" ];

              programs.nix-ld.enable = true;
            }
          ];

          specialArgs = {
            inherit username hostname;
          };
        };
    in
    {
      nixosConfigurations = {
        juxpc = mkHost {
          hostname = "juxpc";
          hardwareConfig = ./nixos/hardware-configuration-juxpc.nix;
          hostConfig = ./nixos/configuration-juxpc.nix;
          homeConfig = ./juxpc.nix;
        };

        juxserver = mkHost {
          hostname = "juxserver";
          hardwareConfig = ./nixos/hardware-configuration-juxserver.nix;
          hostConfig = ./nixos/configuration-juxserver.nix;
          homeConfig = ./juxserver.nix;
        };
      };
    };
}

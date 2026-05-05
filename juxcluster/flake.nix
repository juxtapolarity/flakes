{
  description = "NixOS + Home Manager flake for juxcluster";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    bazecor.url = "path:../bazecor";
    bazecor.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, bazecor, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            bazecor = bazecor.packages.${system}.bazecor;
          })
        ];
      };

      mkHost =
        {
          hostname,
          username,
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
                shell = pkgs.zsh;
              };

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit username hostname;
              };
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
          username = "jux";
          hardwareConfig = ./nixos/hardware-configuration-juxpc.nix;
          hostConfig = ./nixos/configuration-juxpc.nix;
          homeConfig = ./juxpc.nix;
        };

        juxserver = mkHost {
          hostname = "juxserver";
          username = "jux";
          hardwareConfig = ./nixos/hardware-configuration-juxserver.nix;
          hostConfig = ./nixos/configuration-juxserver.nix;
          homeConfig = ./juxserver.nix;
        };

        amaliepc = mkHost {
          hostname = "amaliepc";
          username = "amalie"; # change if her Linux username is different
          hardwareConfig = ./nixos/hardware-configuration-amaliepc.nix;
          hostConfig = ./nixos/configuration-amaliepc.nix;
          homeConfig = ./amaliepc.nix;
        };
      };
    };
}

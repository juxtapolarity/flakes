{
  description = "NixOS + Home Manager flake using local dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "jux";
      hostname = "your-hostname"; # ← replace this with your real hostname (run `hostname`)
      pkgs = import nixpkgs { inherit system; };
    in {
      # NixOS system config
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./nixos/configuration.nix
          ./nixos/hardware-configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.${username} = import ./home.nix;

            users.users.${username} = {
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" ];
            };

            nix.settings.experimental-features = [ "nix-command" "flakes" ];
          }
        ];
      };

      # Optional: use this on Debian or other non-NixOS systems
      # homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      #   inherit pkgs;
      #   modules = [ ./home.nix ];
      # };
    };
}


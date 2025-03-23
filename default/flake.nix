{
  description = "Flake for Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    # Use local path for dotfiles
    dotfiles.url = "path:/home/jux/.config/dotfiles";
    dotfiles.flake = false;
  };

  outputs = { self, nixpkgs, home-manager, dotfiles, ... }: {
    homeConfigurations."jux" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [ ./home.nix ];
      extraSpecialArgs = {
        inherit dotfiles;
      };
    };
  };
}


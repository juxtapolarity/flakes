{
  description = "Flake for Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    dotfiles = {
      url = "github:juxtapolarity/dotfiles";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, dotfiles }: {
    homeConfigurations."jux" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { system = "x86_64-linux"; };
      modules = [ ./home.nix ];
      extraSpecialArgs = { inherit dotfiles; };
    };
  };
}


{
  description = "Python dev env using uv and uv2nix";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.python312
            pkgs.python312Packages.uv
            pkgs.uv2nix  # included in nixpkgs
          ];
        };
      });
}


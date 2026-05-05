{
  description = "Bazecor keyboard configurator for Dygma keyboards";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      packages.${system} =
        let
          bazecor = pkgs.appimageTools.wrapType2 {
            pname = "bazecor";
            version = "1.8.3";

            src = pkgs.fetchurl {
              url = "https://github.com/Dygmalab/Bazecor/releases/download/v1.8.3/Bazecor-1.8.3-x64.AppImage";
              hash = "sha256-OAwHeLLbW+FlKeyxS+MCOTirHCvqZptiYXbeA3l4YJc=";
            };

            meta = {
              description = "Bazecor keyboard configurator for Dygma keyboards";
              homepage = "https://github.com/Dygmalab/Bazecor";
              license = nixpkgs.lib.licenses.gpl3Only;
              platforms = [ "x86_64-linux" ];
              mainProgram = "bazecor";
            };
          };
        in
        {
          inherit bazecor;
          default = bazecor;
        };
    };
}

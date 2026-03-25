{ pkgs, ... }:

{
  imports = [
    ./juxshared.nix
  ];

  home.packages = with pkgs; [
    btop
  ];
}

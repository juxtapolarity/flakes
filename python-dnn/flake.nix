{
  description = "FaceFusion dev shell – OpenGL + correct CUDA driver path";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs   = import nixpkgs { inherit system; };
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.libglvnd
          pkgs.glib
          pkgs.gdb      # optional – for debugging
        ];

        # ──────────────────────────────────────────────────────────────
        # Note by jux!!!
        # This took quite a while to figure out, so please read!
        # 
        # CUDA segfault root cause & fix
        # ──────────────────────────────────────────────────────────────
        # • The dynamic loader was picking up libglvnd’s *stub*
        #   /nix/store/…-libglvnd-*/lib/libcuda.so.1 before the real
        #   driver library in /run/opengl-driver/lib.
        # • The stub is missing recent symbols (e.g. InitializeInjectionCaskEnhanced),
        #   so loading CUDA 12.8 user‑space libs → undefined‑symbol → segfault.
        # • Prepending /run/opengl-driver/lib to LD_LIBRARY_PATH
        #   guarantees the real driver library is found first.
        # • Driver 570.124.04 is already compatible with CUDA 12.8, no
        #   downgrade/upgrade needed.

        # build a colon‑separated path: driver first, then libs from Nix
        LD_LIBRARY_PATH = pkgs.lib.concatStringsSep ":"
          [
            "/run/opengl-driver/lib"
            (pkgs.lib.makeLibraryPath [ pkgs.libglvnd pkgs.glib ])
          ];

        shellHook = ''
          echo "LD_LIBRARY_PATH → $LD_LIBRARY_PATH"
        '';
      };
    };
}


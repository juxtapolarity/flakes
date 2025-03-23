# { config, pkgs, ... }:
#
# let
#   pipewireCustom = pkgs.pipewire.override {
#     withAlsa = true;
#     withPulse = true;
#     withJack = false;
#   };
# in {
#   # By adding pipewireCustom into home.packages, you’re pulling
#   # in the ALSA/Pulse/JACK support for PipeWire in your user
#   # environment, so ncspot can find the .so.
#   home.packages = [
#     pipewireCustom
#   ];
# }
#

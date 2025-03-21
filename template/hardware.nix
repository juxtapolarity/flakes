{ config, pkgs, ... }:
{
  programs.pipewire = {
    enable = true;
    alsa.enable = true;    # Provide ALSA → PipeWire
    pulse.enable = true;   # Provide PulseAudio → PipeWire (optional)
    jack.enable = false;   # Only enable this if you want JACK via PipeWire
  };

  # Put these in your user-level PATH so the ALSA plugin .so is visible
  home.packages = with pkgs; [
    pipewire
    pipewire-alsa
    pipewire-pulse  # optional
  ];
}


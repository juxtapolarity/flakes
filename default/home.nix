{ config, pkgs, dotfiles, ... }:

{
  home.username = "jux";
  home.homeDirectory = "/home/jux";
  home.stateVersion = "24.11"; # Required for compatibility

  # This environment variable points ALSA to the Debian system plugin directory.
  home.sessionVariables = {
    ALSA_PLUGIN_DIR = "/usr/lib/x86_64-linux-gnu/alsa-lib";
  };

  # Install packages via Nix
  home.packages = with pkgs; [
    fzf
    neovim
    tmux
    docker
    ncspot
    # mpv
    # nixGLNvidia
  ];

  # Manage dotfiles by linking them from ~/.config/dotfiles
  home.file = {
    ".config/home-manager".source = "${dotfiles}/home-manager";
    ".zshrc".source = "${dotfiles}/zsh/.zshrc";
    ".config/nvim".source = "${dotfiles}/nvim";
    ".config/mpv".source = "${dotfiles}/mpv";
    ".config/polybar".source = "${dotfiles}/polybar";
    ".tmux".source = "${dotfiles}/tmux";
    ".tmux.conf".source = "${dotfiles}/tmux/.tmux.conf";
    ".config/i3".source = "${dotfiles}/i3";
    ".config/.poshthemes".source = "${dotfiles}/oh-my-posh";
  };

  # Define session variables
  home.sessionVariables = { };

  # Enable Home Manager itself
  programs.home-manager.enable = true;
}

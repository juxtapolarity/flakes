{ config, pkgs, ... }:

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
    ".config/home-manager".source = "${dotfiles}/.config/dotfiles/home-manager";
    ".zshrc".source = "${dotfiles}/.config/dotfiles/zsh/.zshrc";
    ".config/nvim".source = "${dotfiles}/.config/dotfiles/nvim";
    ".config/mpv".source = "${dotfiles}/.config/dotfiles/mpv";
    ".config/polybar".source = "${dotfiles}/.config/dotfiles/polybar";
    ".tmux".source = "${dotfiles}/.config/dotfiles/tmux";
    ".tmux.conf".source = "${dotfiles}/.config/dotfiles/tmux/.tmux.conf";
    ".config/i3".source = "${dotfiles}/.config/dotfiles/i3";
    ".config/.poshthemes".source = "${dotfiles}/.config/dotfiles/oh-my-posh";
  };

  # Define session variables
  home.sessionVariables = { };

  # Enable Home Manager itself
  programs.home-manager.enable = true;
}

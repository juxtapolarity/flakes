{ config, pkgs, ... }:

{
  home.username = "jux";
  home.homeDirectory = "/home/jux";
  home.stateVersion = "24.11"; # Required for compatibility

  # Install packages via Nix
  home.packages = with pkgs; [
    fzf
    neovim
    tmux
  ];

  # Manage dotfiles by linking them from ~/.config/dotfiles
  home.file = {
    ".config/home-manager".source = "${config.home.homeDirectory}/.config/dotfiles/home-manager";
    ".zshrc".source = "${config.home.homeDirectory}/.config/dotfiles/zsh/.zshrc";
    ".config/nvim".source = "${config.home.homeDirectory}/.config/dotfiles/nvim";
    ".config/mpv".source = "${config.home.homeDirectory}/.config/dotfiles/mpv";
    ".config/polybar".source = "${config.home.homeDirectory}/.config/dotfiles/polybar";
    ".tmux".source = "${config.home.homeDirectory}/.config/dotfiles/tmux";
    ".tmux.conf".source = "${config.home.homeDirectory}/.config/dotfiles/tmux/.tmux.conf";
    ".config/i3".source = "${config.home.homeDirectory}/.config/dotfiles/i3";
    ".config/.poshthemes".source = "${config.home.homeDirectory}/.config/dotfiles/oh-my-posh";
  };

  # Define session variables
  home.sessionVariables = { };

  # Enable Home Manager itself
  programs.home-manager.enable = true;
}

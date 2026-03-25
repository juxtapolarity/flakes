{ config, pkgs, username, ... }:

let
  dotfilesPath = "${config.home.homeDirectory}/.config/dotfiles";
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    fzf
    git
    neovim
    oh-my-posh
    ripgrep
    tmux
    unzip
    uv
    vim
    xclip
    zsh
    zsh-autosuggestions
    zsh-history-substring-search
    zsh-syntax-highlighting
    zoxide
  ];

  home.file = {
    ".zshrc".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/zsh/.zshrc";

    ".config/nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/nvim";

    ".tmux".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/tmux";

    ".tmux.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/tmux/.tmux.conf";

    ".config/.poshthemes".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/oh-my-posh";

    ".config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh".source =
      "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh";

    ".config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh".source =
      "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";

    ".config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh".source =
      "${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh";
  };

  programs.home-manager.enable = true;
}

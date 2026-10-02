{
  config,
  pkgs,
  inputs,
  lib,
  # pake-youtube-music,
  ...
}:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      nerdtree
      vim-fugitive
      syntastic
      ctrlp-vim
      indentLine
      vimsence
      onedark-nvim
      vim-devicons
      cmp-nvim-lsp
      cmp-vsnip
      cmp-path
      cmp-buffer
      nvim-cmp
      nerdtree-git-plugin
    ];
    extraConfig = lib.fileContents ./neovim/config.vim;
  };
}

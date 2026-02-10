{
  config,
  wlib,
  lib,
  pkgs,
  ...
}: {
  imports = [wlib.wrapperModules.neovim];
  config.settings.config_directory = ./lua;

  config.specs.core = {
    data = with pkgs.vimPlugins; [
      lze
      lzextras
      vim-repeat
      plenary-nvim
      nvim-notify
      nvim-web-devicons
      nvim-lspconfig
      conform-nvim
      nvim-lint
    ];
    extraPackages = with pkgs; [
      universal-ctags
      ripgrep
      fd
      tree-sitter
    ];
  };

  config.specs.debug = {
    after = ["core"];
    lazy = true;
    data = with pkgs.vimPlugins; [
      {
        data = nvim-nio;
        lazy = false;
      }
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
    ];
    extraPackages = with pkgs; [];
  };

  config.specs.completion = {
    after = ["core"];
    lazy = true;
    data = with pkgs.vimPlugins; [
      luasnip
      cmp-cmdline
      blink-cmp
      blink-compat
      colorful-menu-nvim
    ];
  };

  config.specs.syntax = {
    after = ["core"];
    lazy = true;
    data = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      rainbow-delimiters-nvim
      nvim-ufo
    ];
  };

  config.specs.search = {
    after = ["core"];
    lazy = true;
    data = with pkgs.vimPlugins; [
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
      flash-nvim
    ];
  };

  config.specs.editing = {
    after = ["core"];
    lazy = true;
    data = with pkgs.vimPlugins; [
      which-key-nvim
      indent-blankline-nvim
      comment-nvim
      undotree
      vim-sleuth
      mini-nvim
      snacks-nvim
      todo-comments-nvim
      nvim-colorizer-lua
    ];
  };

  config.specs.ui = {
    after = ["core"];
    lazy = true;
    data = with pkgs.vimPlugins; [
      fidget-nvim
      lualine-nvim
      bufferline-nvim
      neo-tree-nvim
      edgy-nvim
      nui-nvim
      noice-nvim
      trouble-nvim
      toggleterm-nvim
    ];
  };

  config.specs.git = {
    after = ["core"];
    lazy = true;
    data = with pkgs.vimPlugins; [
      gitsigns-nvim
    ];
  };

  config.specs.ai = {
    after = ["ui" "completion"];
    lazy = true;
    data = with pkgs.vimPlugins; [
      avante-nvim
      blink-cmp-avante
    ];
  };

  config.specs.productivity = {
    after = ["core"];
    lazy = true;
    data = with pkgs.vimPlugins; [
      vim-wakatime
    ];
  };

  config.specs.nix = {
    data = null;
    extraPackages = with pkgs; [
      statix
      nixd
      nix-doc
      alejandra
    ];
  };
  config.specs.lua = {
    after = ["core"];
    lazy = true;
    data = with pkgs.vimPlugins; [
      lazydev-nvim
    ];
    extraPackages = with pkgs; [
      lua-language-server
      stylua
    ];
  };

  config.specMods = {
    parentSpec ? null,
    parentOpts ? null,
    parentName ? null,
    config,
    ...
  }: {
    # add an extraPackages field to the specs themselves
    options.extraPackages = lib.mkOption {
      type = lib.types.listOf wlib.types.stringable;
      default = [];
      description = "a extraPackages spec field to put packages to suffix to the PATH";
    };
  };
  config.extraPackages = config.specCollect (acc: v: acc ++ (v.extraPackages or [])) [];

  # Inform our lua of which top level specs are enabled
  options.settings.cats = lib.mkOption {
    readOnly = true;
    type = lib.types.attrsOf lib.types.bool;
    default = builtins.mapAttrs (_: v: v.enable) config.specs;
  };
}

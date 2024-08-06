{ userSettings, systemSettings, pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin.enable = true;

    globals.mapleader = " "; 
    keymaps = [
    {
      mode = "n";
      action = "<cmd>Telescope live_grep<CR>";
      key = "<C-p>";
    }
    {
      mode = "n";
      action = ":Neotree filesystem close<CR>";
      key = "<C-f>";
    }
    {
      mode = "n";
      action = ":Neotree filesystem focus<CR>";
      key = "<leader>ff";
    }
    ];
    plugins = {

      lsp = {
	enable = true;
	servers = {
	  tsserver.enable = true;
	  lua-ls.enable = true;
	  rust-analyzer.enable = true;
	  nixd.enable = true;
	  zls.enable = true;
	  clang.enable = true;
	  bash.enable = true
	};
      };

      treesitter = {
	enable = true;
	ensureInstalled = [
	  "lua"
	    "javascript"
	    "nix"
	    "zig"
	    "c"
	    "cpp"
	    "bash"
	];
	indent = true;
      };
      telescope.enable = true;	
      lualine.enable = true;
      neo-tree.enable = true;
    };

    opts = {
      number = true;
      relativenumber = true;
      autoindent = true;
      shiftwidth = 2;
      colorcolumn = 80;
    };
  };

}

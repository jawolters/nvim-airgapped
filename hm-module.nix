# home-manager module
# Usage in home.nix:
#   inputs.nvim-airgap.homeManagerModules.default
#
# Sets up the nvim-airgap package and optionally manages your nvim config
# as home-manager files (so the config is also reproducible).
self:
{ config, lib, pkgs, ... }:
let
  cfg = config.programs.nvim-airgap;
in
{
  options.programs.nvim-airgap = {
    enable = lib.mkEnableOption "air-gapped LazyVim bundle";

    # Path to your user config directory (lua files only, no bootstrap).
    # If null, ~/.config/nvim is used as-is.
    configDir = lib.mkOption {
      type    = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to your nvim user config (lua/config/, lua/plugins/)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ self.packages.${pkgs.system}.default ];

    # If you manage your config via Nix, link it into XDG_CONFIG_HOME.
    # Otherwise just keep ~/.config/nvim as a normal directory.
    xdg.configFile = lib.mkIf (cfg.configDir != null) {
      "nvim" = {
        source    = cfg.configDir;
        recursive = true;
      };
    };
  };
}

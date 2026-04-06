{
  description = "Air-gapped LazyVim bundle";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # AppImage bundler - packages the Nix closure as a standalone AppImage
    nix-appimage = {
      url = "github:ralismark/nix-appimage";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixvim, nix-appimage }:
    let
      systems = [ "x86_64-linux" ];
      forEachSystem = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forEachSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          # Build the neovim package using nixvim.
          # nixvim installs all plugins into the Nix store and generates a
          # wrapper that points lazy.nvim to those pre-fetched paths - no
          # network access required at runtime.
          nvimPkg = nixvim.legacyPackages.${system}.makeNixvimWithModule {
            module = ./neovim-module.nix;
          };
        in
        {
          default = nvimPkg;
          nvim = nvimPkg;

          # nix build .#appimage  ->  produces nvim.AppImage
          # Bundles the entire Nix closure (neovim + all plugins + runtimes)
          # into a single self-contained AppImage.
          appimage = nix-appimage.bundlers.${system}.default nvimPkg;
        });

      # Use as an overlay in NixOS / home-manager
      overlays.default = _final: _prev: {
        nvim-airgap = self.packages.${_prev.system}.default;
      };

      # home-manager module: adds the nvim package and wires XDG config
      homeManagerModules.default = import ./hm-module.nix self;
    };
}

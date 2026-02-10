{
  description = "Personal nvim config, to be used in nix";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    wrappers,
    flake-parts,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [wrappers.flakeModules.wrappers];
      systems = nixpkgs.lib.platforms.all;

      perSystem = {pkgs, ...}: {
        # wrappers.pkgs = pkgs; # choose a different `pkgs`
        wrappers.control_type = "exclude"; # | "build"  (default: "exclude")
        wrappers.packages = {};
      };
      flake.wrappers.default = ./module.nix;
    };
}

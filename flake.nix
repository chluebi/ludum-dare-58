# flake.nix
{
  description = "A simple Nix flake for the Godot game engine";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    # Add flake-utils as an input
    flake-utils.url = "github:numtide/flake-utils";
  };

  # Add flake-utils to the function arguments
  outputs = { self, nixpkgs, flake-utils }:
    # Use the function from flake-utils instead of nixpkgs.lib
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.godot;

        devShells.default = pkgs.mkShell {
          name = "godot-environment";
          buildInputs = [
            pkgs.godot
          ];
        };
      });
}

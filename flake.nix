{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    appimage-file-weekly = {
      url = "https://github.com/FreeCAD/FreeCAD-Bundle/releases/download/weekly-builds/FreeCAD_weekly-builds-41264-conda-Linux-x86_64-py311.AppImage";
      flake = false;
    };
    appimage-file-rt = {
      url = "https://github.com/realthunder/FreeCAD/releases/download/20241003stable/FreeCAD-Link-Stable-Linux-x86_64-py3.11-20241003.AppImage";
      flake = false;
    };
    astocad-src = {
      type = "git";
      url = "https://github.com/AstoCAD/FreeCAD";
      ref = "AstoCAD";
      submodules = true;
      flake = false;
    };
    freecad-src = {
      type = "git";
      url = "https://github.com/FreeCAD/FreeCAD";
      ref = "main";
      submodules = true;
      flake = false;
    };
  };

  outputs = { nixpkgs, ... }@inputs: {
    packages = builtins.listToAttrs (map (system: {
        name = system;
        value = with import nixpkgs { inherit system; config.allowUnfree = true;}; rec {
          freecad-appimage = pkgs.callPackage (import ./package/appimage-default.nix) { src = inputs.appimage-file-weekly;  pname = "freecad"; version = "stable"; };
          freecad-weekly-appimage = pkgs.callPackage (import ./package/appimage-default.nix) { src = inputs.appimage-file-weekly;  pname = "freecad"; version = "weekly"; };
          freecadrt-appimage = pkgs.callPackage (import ./package/appimage-default.nix) { src = inputs.appimage-file-rt; pname = "freecad-rt"; version = "stable"; };
          astocad = pkgs.callPackage (import ./package/default.nix) { src = inputs.astocad-src; pname = "astocad"; version = "dev"; };
          freecad = pkgs.callPackage (import ./package/default.nix) { src = inputs.freecad-src; pname = "freecad"; version = "dev"; };
          default = freecad-appimage;
        };
      })[ "x86_64-linux" ]);
  };
}

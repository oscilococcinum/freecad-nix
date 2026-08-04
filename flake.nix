{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    appimage-file-weekly = {
      url = "https://github.com/FreeCAD/FreeCAD/releases/download/weekly-2026.07.22/FreeCAD_weekly-2026.07.22-Linux-x86_64.AppImage";
      flake = false;
    };
    appimage-file-stable = {
      url = "https://github.com/FreeCAD/FreeCAD/releases/download/1.1.3/FreeCAD_1.1.3-Linux-x86_64-py311.AppImage";
      flake = false;
    };
    appimage-file-rt = {
      url = "https://github.com/realthunder/FreeCAD/releases/download/Tip/FreeCAD-Link-Tip-Linux-x86_64-py3.11-20251015.AppImage";
      flake = false;
    };
    astocad-dev-src = {
      type = "tarball";
      url = "https://github.com/AstoCAD/FreeCAD/releases/download/weekly-builds/freecad_source.tar.gz";
      flake = false;
    };
    freecad-stable-src = {
      type = "tarball";
      url = "https://github.com/FreeCAD/FreeCAD/releases/download/1.1.3/freecad_source_1.1.3.tar.gz";
      flake = false;
    };
    freecad-dev-src = {
      type = "git";
      url = "https://github.com/FreeCAD/FreeCAD";
      ref = "main";
      submodules = true;
      flake = false;
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      packages = builtins.listToAttrs (
        map (system: {
          name = system;
          value =
            with import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            }; rec {
              freecad-appimage = pkgs.callPackage (import ./package/appimage-default.nix) {
                src = inputs.appimage-file-stable;
                pname = "freecad";
                version = "stable";
              };
              freecad-weekly-appimage = pkgs.callPackage (import ./package/appimage-default.nix) {
                src = inputs.appimage-file-weekly;
                pname = "freecad";
                version = "weekly";
              };
              freecadrt-appimage = pkgs.callPackage (import ./package/appimage-default.nix) {
                src = inputs.appimage-file-rt;
                pname = "freecad-rt";
                version = "stable";
              };
              astocad-dev = pkgs.callPackage (import ./package/default.nix) {
                src = inputs.astocad-dev-src;
                pname = "astocad";
                version = "dev";
              };
              freecad-stable = pkgs.callPackage (import ./package/default.nix) {
                src = inputs.freecad-stable-src;
                pname = "freecad";
                version = "1.1.3";
              };
              freecad-dev = pkgs.callPackage (import ./package/default.nix) {
                src = inputs.freecad-dev-src;
                pname = "freecad";
                version = "dev";
              };
              default = freecad-appimage;
            };
        }) [ "x86_64-linux" ]
      );
    };
}

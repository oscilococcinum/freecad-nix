{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    appimage-file-weekly = {
      url = "https://github.com/FreeCAD/FreeCAD/releases/download/weekly-2026.11.11/FreeCAD_weekly-2026.11.11-Linux-x86_64.AppImage";
      flake = false;
    };
    appimage-file-stable = {
      url = "https://github.com/FreeCAD/FreeCAD/releases/download/1.1.3/FreeCAD_1.1.3-Linux-x86_64-py311.AppImage";
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
              default = freecad-appimage;
            };
        }) [ "x86_64-linux" ]
      );
    };
}

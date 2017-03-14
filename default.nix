{ pkgs ? (import <nixpkgs> {}), pythonPackages ? "python35Packages" }:
let
  inherit (pkgs.lib) fix extends;
  basePythonPackages = with builtins; if isAttrs pythonPackages
    then pythonPackages
    else getAttr pythonPackages pkgs;

  # Works with the new python-packages, still can fallback to the old
  # variant.
  basePythonPackagesUnfix = basePythonPackages.__unfix__ or (
    self: basePythonPackages.override (a: { inherit self; }));

  elem = builtins.elem;
  basename = path: with pkgs.lib; last (splitString "/" path);
  startsWith = prefix: full: let
    actualPrefix = builtins.substring 0 (builtins.stringLength prefix) full;
  in actualPrefix == prefix;

  src-filter = path: type: with pkgs.lib;
    let
      ext = last (splitString "." path);
    in
      !elem (basename path) [".git" "__pycache__" ".eggs"] &&
      !elem ext ["egg-info" "pyc"] &&
      !startsWith "result" path;

  sample-src = builtins.filterSource src-filter ./.;

  pythonPackagesGenerated = self: super: (scopedImport {
    inherit pkgs self super;
    inherit (pkgs) fetchurl fetchgit;
  } ./pkgs/python-packages.nix);

  pythonPackagesOverrides = import ./pkgs/python-packages-overrides.nix {
    inherit
      basePythonPackages
      pkgs;
  };

  pythonPackagesLocalOverrides = self: super: {
    sample = super.sample.override (attrs: {
      src = sample-src;
    });
  };

  myPythonPackages =
    (fix
    (extends pythonPackagesLocalOverrides
    (extends pythonPackagesOverrides
    (extends pythonPackagesGenerated
             basePythonPackagesUnfix))));

in myPythonPackages.sample

{ pkgs ? (import <nixpkgs> {}), pythonPackages ? "python27Packages" }:
let
  basePythonPackages = with builtins; if isAttrs pythonPackages
    then pythonPackages
    else getAttr pythonPackages pkgs;

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

  localOverrides = pythonPackages: {
    sample = pythonPackages.sample.override (attrs: {
      src = sample-src;
    });
  };

  pythonPackagesWithLocals = basePythonPackages.override (a: {
    self = pythonPackagesWithLocals;
  })
  // (scopedImport {
    self = pythonPackagesWithLocals;
    super = basePythonPackages;
    inherit pkgs;
    inherit (pkgs) fetchurl fetchgit;
  } ./python-packages.nix);

  myPythonPackages =
    pythonPackagesWithLocals
    // (localOverrides pythonPackagesWithLocals);
in myPythonPackages.sample
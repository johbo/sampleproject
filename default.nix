{ pkgs ? (import <nixpkgs> {}) }:

pkgs.python36Packages.buildPythonPackage {
  name = "sample-1.2.0";
  src = ./.;
}

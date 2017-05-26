{ pkgs ? (import <nixpkgs> {}) }:

let
  pythonPackages = pkgs.python36Packages;

in pythonPackages.buildPythonPackage {
  name = "sample-1.2.0";
  src = ./.;

  propagatedBuildInputs = [ pythonPackages.peppercorn ];
}

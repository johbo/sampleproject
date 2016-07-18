{ pkgs, basePythonPackages }:

self: super: {

  peppercorn = super.peppercorn.override (attrs: {
    doCheck = true;
  });

}

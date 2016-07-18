{
  peppercorn = super.buildPythonPackage {
    name = "peppercorn-0.5";
    buildInputs = with self; [];
    doCheck = false;
    propagatedBuildInputs = with self; [];
    src = fetchurl {
      url = "https://pypi.python.org/packages/45/ec/a62ec317d1324a01567c5221b420742f094f05ee48097e5157d32be3755c/peppercorn-0.5.tar.gz";
      md5 = "f08efbca5790019ab45d76b7244abd40";
    };
  };
  sample = super.buildPythonPackage {
    name = "sample-1.2.0";
    buildInputs = with self; [];
    doCheck = false;
    propagatedBuildInputs = with self; [peppercorn];
    src = ./.;
  };

### Test requirements

  
}

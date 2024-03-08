{ buildRosPackage
, ament-flake8
, ament-copyright
, ament-mypy
, ament-pep257
, python3Packages
,
}:
buildRosPackage {
  pname = "random_subscriber";
  version = "0.0.0";

  src = ./.;

  buildType = "ament_python";
  checkInputs = [ ament-copyright ament-flake8 ament-mypy ament-pep257 python3Packages.pytest ];
}

{ buildRosPackage
, ament-flake8
, ament-copyright
, ament-mypy
, ament-pep257
, python3Packages
, random-pubsub-interfaces
,
}:
buildRosPackage {
  pname = "random_publisher";
  version = "0.0.0";
  src = ./.;
  buildType = "ament_python";
  propagatedBuildInputs = [
    random-pubsub-interfaces
  ];
  checkInputs = [
    ament-copyright
    ament-flake8
    ament-mypy
    ament-pep257
    python3Packages.pytest
  ];
}

{ buildRosPackage
#, cmake
, ament-cmake
, random-publisher
, random-subscriber
, ament-lint-auto
, ament-lint-common
,
}:
buildRosPackage {
  pname = "random_bringup";
  version = "0.0.0";

  src = ./.;

  buildType = "ament_cmake";

  propagatedBuildInputs = [
    random-publisher
    random-subscriber
  ];

  nativeBuildInputs = [
    ament-cmake
  ];

  checkInputs = [
    ament-lint-auto
    ament-lint-common
  ];
}

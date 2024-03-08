{ buildRosPackage
, cmake
, ament-cmake
, ament-lint-auto
, ament-lint-common
, rosidl-default-generators
, rosidl-default-runtime
,
}:
buildRosPackage {
  pname = "random_pubsub_interfaces";
  version = "0.0.0";
  src = ./.;
  buildType = "ament_cmake";
  propagatedBuildInputs = [
    ament-cmake
    rosidl-default-runtime
  ];
  nativeBuildInputs = [
    cmake
    rosidl-default-generators
  ];
  checkInputs = [
    ament-lint-auto
    ament-lint-common
  ];
}

This `flake.nix` will allow you to get a development environment for the custom
ROS packages defined in the repo.

`nix develop github:genkiinstruments/workshop-2024?dir=ros2-nix-example`

or if you have the repo cloned locally, `cd ros2-nix-example` and `nix develop`

Once inside of the devshell, you should be able to `ros2 launch random_bringup
test_pub_sub_launch.py`

This `flake.nix` will allow you to run a virtual machine running `roscore`, and that has `gazebo` in the environment.

![image](https://github.com/genkiinstruments/workshop-2024/assets/26458780/64f29b28-10b3-4444-b99f-351830105bf0)

`nix run github:genkiinstruments/workshop-2024?dir=ros-vm#vm`

or if you have the repo cloned locally

`nix run .#vm`

- `.` means current directory
- `#` means output of
- `vm` is the name of the output

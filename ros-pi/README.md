This `flake.nix` will build an SD Image for a Raspberry Pi 4 that is running
XFCE, `roscore`, and has `gazebo`.

### On NixOS
If you're running NixOS and want to use this template to build the Raspberry Pi
4 Image, you'll need to emulate an arm64 machine by adding the following to your
NixOS configuration.

```
{
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
```

Then you will be able to run `nix build .#ros-pi-sdImage` and get a result you can
flash to an SD Card and boot.

If you are not running NixOS you will have to follow complex documentation for
your distribution, for example https://wiki.debian.org/QemuUserEmulation to
enable arm64 emulation

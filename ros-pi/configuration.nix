{ pkgs, lib, config, modulesPath, ... }:
{
  imports = [
    # Import the minimal profile from Nixpkgs which makes the ISO image a
    # little smaller
    "${modulesPath}/profiles/minimal.nix"

    # Import the ./wireless.nix file which sets up the WiFi
    ./wireless.nix
  ];

  # Enable ssh
  services.openssh.enable = true;

  networking.hostName = "ros-pi";

  # Add a user 'default' to the system
  users = {
    users.default = {
      password = "default";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };


  # Enable flakes
  nix.settings = {
    experimental-features = lib.mkDefault "nix-command flakes";
    trusted-users = [ "root" "@wheel" ];
  };

  # This causes an overlay which causes a lot of rebuilding
  environment.noXlibs = lib.mkForce false;

  # Enable GPU acceleration
  hardware.opengl.enable = true;

  # Use the latest kernel
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

  # default to stateVersion for current lock
  system.stateVersion = config.system.nixos.version;
}


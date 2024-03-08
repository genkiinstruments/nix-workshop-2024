{ pkgs, lib, config, ... }:
{
  # Enable SSH
  services.openssh.enable = true;

  networking.hostName = "ros-vm";

  # Add a user to the system called 'default' with password 'default'
  # This user can use sudo because they are in the 'wheel' group
  users = {
    users.default = {
      password = "default";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  # Enable Nix flakes
  # Add users in the 'wheel' group to trusted users
  nix.settings = {
    experimental-features = lib.mkDefault "nix-command flakes";
    trusted-users = [ "root" "@wheel" ];
  };

  # Enable opengl acceleration (mesa)
  hardware.opengl.enable = true;

  # Use the latest kernel
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

  # default to stateVersion for current lock
  system.stateVersion = config.system.nixos.version;
}


{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay";
  };
  outputs = { self, nixpkgs, nixos-hardware, flake-parts, nix-ros-overlay }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      perSystem = { system, pkgs, ... }: {
      };
      flake = { ... }: {
        packages.x86_64-linux.ros-pi-sdImage = self.packages.aarch64-linux.ros-pi-sdImage;
        packages.aarch64-linux.ros-pi-sdImage = (self.nixosConfigurations.ros-pi.extendModules {
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            {
              disabledModules = [ "profiles/base.nix" ];
            }
          ];
        }).config.system.build.sdImage;
        nixosConfigurations = {
          ros-pi = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              {
                environment.systemPackages = [ nix-ros-overlay.legacyPackages.aarch64-linux.humble.gazebo ];
                services.ros.enable = true;
                services.xserver = {
                  enable = true;
                  desktopManager = {
                    xterm.enable = false;
                    xfce.enable = true;
                  };
                  displayManager.defaultSession = "xfce";
                };
              }
              nix-ros-overlay.nixosModules.default
              nixos-hardware.nixosModules.raspberry-pi-4
              ./configuration.nix
              ./pi-requirements.nix
            ];
          };
        };
      };
    };
}



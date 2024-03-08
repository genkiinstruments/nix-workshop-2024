{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay";
  };
  outputs = { self, nixpkgs, flake-parts, nix-ros-overlay }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
      perSystem = { system, pkgs, ... }: {
        apps.vm = let
          vmScript = (nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ./configuration.nix
              {
                environment.systemPackages = [ nix-ros-overlay.legacyPackages.${system}.humble.gazebo ];
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
            ];
          }).config.system.build.vm;
        in {
          type = "app";
          program = builtins.toPath (pkgs.writeShellScript "stateless-kiosk-vm" ''
            TMPDIR=$(mktemp -d)
            function cleanup {
              rm -rf "$TMPDIR"
            }
            trap cleanup 0
            cd $TMPDIR
            ${pkgs.lib.getExe vmScript}
          '');
        };
      };
    };
}



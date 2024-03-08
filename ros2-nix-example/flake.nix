{
  nixConfig = {
    extra-substituters = [ "https://ros.cachix.org" ];
    extra-trusted-public-keys = [ "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo=" ];
  };

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:lopsided98/nixpkgs/61852b7faa8b47aad422adca0fea90fe007e9ead";
    nixros.url = "github:lopsided98/nix-ros-overlay";
    nixpkgs.follows = "nixros/nixpkgs";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = let
        my-ros-distro-overlay = (final: prev: {
          random-bringup = prev.callPackage ./random_bringup {};
          random-publisher = prev.callPackage ./random_publisher {};
          random-pubsub-interfaces = prev.callPackage ./random_pubsub_interfaces {};
          random-subscriber = prev.callPackage ./random_subscriber {};
        });
        my-ros-overlay = (self: super: {
          # Apply our overlay to multiple ROS distributions
          rosPackages = super.rosPackages // {
            noetic = super.rosPackages.noetic.overrideScope my-ros-distro-overlay;
            foxy = super.rosPackages.foxy.overrideScope my-ros-distro-overlay;
            humble = super.rosPackages.humble.overrideScope my-ros-distro-overlay;
            iron = super.rosPackages.iron.overrideScope my-ros-distro-overlay;
            rolling = super.rosPackages.rolling.overrideScope my-ros-distro-overlay;
          };
        });
      in { config, self', inputs', pkgs, system, ... }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.nixros.overlays.default
            my-ros-overlay
          ];
        };
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs.rosPackages.iron; [
            (buildEnv {
              paths = [
                random-bringup
                ros-core
              ];
            })
          ];
        };
      };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
    };
}

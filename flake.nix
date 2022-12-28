{
  description = "ExFleetYards Fleetyards api backend";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    devenv.url = "github:cachix/devenv";
  };

  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  outputs = { self, nixpkgs, devenv, ... } @ inputs:
    let
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = f: builtins.listToAttrs (map (name: { inherit name; value = f name; }) systems);

      version = "${nixpkgs.lib.substring 0 8 self.lastModifiedDate}-${
          self.shortRev or "dirty"
        }";

      # Memoize nixpkgs for different platforms for efficiency.
      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        });
    in
    {
      overlays.fleet = final: prev: {
        appsignal_nif = final.callPackage ./nix/appsignal-nif.nix { };
        ex_fleet_yards = final.callPackage ({ lib, beam, rebar3, beamPackages, appsignal_nif }: 
        let 
            packages = beam.packagesWith beam.interpreters.erlang;
            pname = "ex_fleet_yards";
            src = self;
            mixEnv = "prod";

            mixDeps = import ./nix/mix.nix { inherit lib beamPackages; overrides = overrideDeps; };

            overrideDeps = (self: super: {
              appsignal = super.appsignal.override {
                prePatch = ''
                  cp ${appsignal_nif}/* c_src
                '';
              };
            });
        in packages.mixRelease {
            inherit pname version src mixEnv;

            mixNixDeps = mixDeps;

            nativeBuildInputs = [ rebar3 ];
        }) { };
      };
      overlays.default = self.overlays.fleet;

      packages = forAllSystems (system: {
        inherit (nixpkgsFor.${system}) ex_fleet_yards appsignal_nif;
        default = self.packages.${system}.ex_fleet_yards;
      });

      legacyPackages = forAllSystems (system: nixpkgsFor.${system});

      devShells = forAllSystems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
            };
          in
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                {
                  packages = with pkgs; [ mix2nix git ];
                  languages.elixir.enable = true;

                  enterShell = ''
                  '';
                  pre-commit.hooks.actionlint.enable = true;
                  pre-commit.hooks.nixfmt.enable = true;
                  pre-commit.hooks.mixfmt = {
                    enable = true;
                    name = "Mix format";
                    entry = "mix format";
                    files = "\\.(ex|exs)$";

                    types = [ "text" "ex" "exs "];
                    language = "system";
                    pass_filenames = false;
                  };
                }
                {
                  env.FLEETYARDS_IN_DEVENV = 1;
                  services.postgres.enable = true;
                  services.postgres.initialDatabases = [{
                      name = "fleet_yards_dev";
                    }
                  ];
                }
                ({config, ...}: {
                  process.implementation = "hivemind";
                  scripts.devenv-up.exec = ''
                    ${config.procfileScript}
                  '';

                })
              ];
            };
          });

          checks = forAllSystems (system: {devenv_ci = self.devShells.${system}.default.ci; });
    };

  nixConfig = {
    extra-substituters = [ "https://fleetbot.cachix.org" ];
    extra-trusted-public-keys =
      [ "fleetbot.cachix.org-1:LCc89Bys++LoaCDgLuO47dcIoSFlRlPvXchGkr5LJLc=" ];
  };
}

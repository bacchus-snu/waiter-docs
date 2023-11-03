{
  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        lib = nixpkgs.lib;
        pkgs = nixpkgs.legacyPackages.${system};
        pkg = self.packages.${system}.default;
      in
      {
        packages = {
          default = pkgs.stdenvNoCC.mkDerivation {
            name = "waiter-docs";
            src = ./.;

            nativeBuildInputs = with pkgs; [ mdbook mdbook-i18n-helpers ];

            buildPhase = ''
              mdbook build -d $out
            '';
          };
          docker =
            let
              caddyfile = pkgs.writeText "Caddyfile" ''
                :8080 {
                  root * ${pkg}
                  file_server
                  handle_errors {
                    rewrite * /{err.status_code}.html
                    file_server
                  }

                  # much performance
                  encode zstd gzip

                  # such secure
                  header {
                    X-Frame-Options DENY
                    X-XSS-Protection 0
                    X-Content-Type-Options nosniff
                    Referrer-Policy strict-origin-when-cross-origin
                    Strict-Transport-Security max-age=31536000
                  }
                }
              '';
            in
            pkgs.dockerTools.buildLayeredImage {
              name = "secure-front";
              config = {
                User = "1000";
                Cmd = [
                  (lib.getExe pkgs.caddy)
                  "run"
                  "--adapter=caddyfile"
                  "--config=${caddyfile}"
                ];
              };
            };
        };
      }
    );
}

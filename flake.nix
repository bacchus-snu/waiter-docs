{
  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        lib = nixpkgs.lib;
        pkgs = nixpkgs.legacyPackages.${system};
        placeholder = self.packages.${system}.placeholder;
      in
      {
        packages = {
          placeholder = pkgs.stdenvNoCC.mkDerivation {
            name = "placeholder";
            src = pkgs.fetchFromGitHub {
              owner = "bacchus-snu";
              repo = "snucse-gpu-service-manual";
              rev = "3dd6d4df9b6c8ffbcc6073826527f119c7fd937f";
              hash = "sha256-e9GANnoJpUggZROINZ0kxtrjA4uubrhzEIWjNCONE5U=";
            };

            postPatch = ''
              cat <<EOF > src/robots.txt
              User-Agent: *
              Disallow: /
              EOF
            '';

            nativeBuildInputs = with pkgs; [ mdbook mdbook-i18n-helpers ];

            buildPhase = ''
              mdbook build -d $out
            '';
          };
          docker =
            let
              caddyfile = pkgs.writeText "Caddyfile" ''
                :8080 {
                  root * ${placeholder}
                  file_server
                  handle_errors {
                    rewrite * /{err.status_code}.html
                    file_server
                  }

                  # such secure
                  header {
                    X-Frame-Options DENY
                    X-XSS-Protection 0
                    X-Content-Type-Options nosniff
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

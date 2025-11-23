{
  description = "Small Bets Rails Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        ruby = pkgs.ruby_3_3;
        
        # System dependencies for Gems
        buildInputs = with pkgs; [
          # Ruby and core tools
          ruby
          bundler
          
          # Node.js / JS Runtime
          nodejs_22
          bun
          yarn

          # Database & Data Stores
          sqlite
          redis
          
          # Image Processing
          vips
          imagemagick
          
          # System Libraries often needed by Gems
          libyaml
          libxml2
          libxslt
          zlib
          openssl
          gnumake
          gcc
          pkg-config
          
          # For capybara/selenium if needed
          # chromium
          # chromedriver
        ];

      in
      {
        devShells.default = pkgs.mkShell {
          inherit buildInputs;

          shellHook = ''
            # Setup local gem path
            export GEM_HOME=$PWD/.nix-gems
            export PATH=$GEM_HOME/bin:$PATH
            export PATH=$PWD/bin:$PATH

            # Add local node_modules to PATH
            export PATH=$PWD/node_modules/.bin:$PATH

            # Ensure bundler is installed
            gem install bundler:2.5.6 --no-document

            echo "🚀 Small Bets Dev Environment Loaded!"
            echo "Ruby: $(ruby --version)"
            echo "Node: $(node --version)"
            echo "Bun: $(bun --version)"
          '';
        };
      }
    );
}

let
  pkgs = import <nixpkgs> {};
  stdenv = pkgs.stdenv;
  ruby = pkgs.ruby_2_4;
  rubygems = (pkgs.rubygems.override { ruby = ruby; });
in stdenv.mkDerivation rec {
  name = "rails-nix";

  buildInputs = with pkgs; [
    ruby
    bundler
    libxml2
    libxslt
    nodejs-10_x

    zlib
    bzip2
    openssl
    pkgconfig

    which
    less
    vim
    gnumake
    git
    curl
  ];

  shellHook = with pkgs; ''
    ## create the gems repo
    mkdir -p .nix-gems

    ## environment variables
    export PKG_CONFIG_PATH=${libxml2}/lib/pkgconfig:${libxslt}/lib/pkgconfig:${zlib}/lib/pkgconfig
    export GEM_HOME=$PWD/.nix-gems
    export GEM_PATH=$GEM_HOME
    export PATH=$GEM_HOME/bin:$PATH
    export PS1="\[\033[1;32m\][nix-shell:\w]\n[★]\[\033[0m\] "
    export LANG=en_US.UTF-8
    export LANGUAGE=en_US.UTF-8
    export LC_ALL=C.UTF-8

    ## change CWD; use with the impure shell
    [[ -n "$D" ]] && cd $D
  '';
}

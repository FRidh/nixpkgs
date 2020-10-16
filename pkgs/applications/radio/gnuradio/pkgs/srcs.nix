{ lib
, ver
# Needed for fetching sources
, pkgs
}:

let
  knownSrcs = {
    osmosdr = {
      "3.7" = rec {
        version = "0.1.5";
        src = pkgs.fetchgit {
          url = "git://git.osmocom.org/gr-osmosdr";
          rev = "v${version}";
          sha256 = "0bf9bnc1c3c4yqqqgmg3nhygj6rcfmyk6pybi27f7461d2cw1drv";
        };
      };
      "3.8" = rec {
        version = "0.2.2";
        src = pkgs.fetchgit {
          url = "git://git.osmocom.org/gr-osmosdr";
          rev = "v${version}";
          sha256 = "HT6xlN6cJAnvF+s1g2I1uENhBJJizdADlLXeSD0rEqs=";
        };
      };
    };
    ais = {
      "3.7" = {
        version = "2015-12-20";
        src = pkgs.fetchFromGitHub {
          owner = "bistromath";
          repo = "gr-ais";
          # Upstream PR: https://github.com/bistromath/gr-ais/commit/8502d0252a2a1a9b8d1a71795eaeb5d820684054
          rev = "8502d0252a2a1a9b8d1a71795eaeb5d820684054";
          sha256 = "1b9j0kc74cw12a7jv4lii77dgzqzg2s8ndzp4xmisxksgva1qfvh";
        };
      };
    };
    gsm = {
      "3.7" = {
        version = "2016-08-25";
        src = pkgs.fetchFromGitHub {
          owner = "ptrkrysik";
          repo = "gr-gsm";
          rev = "3ca05e6914ef29eb536da5dbec323701fbc2050d";
          sha256 = "13nnq927kpf91iqccr8db9ripy5czjl5jiyivizn6bia0bam2pvx";
        };
      };
    };
    nacl = {
      "3.7" = {
        version = "2017-04-10";
        src = pkgs.fetchFromGitHub {
          owner = "stwunsch";
          repo = "gr-nacl";
          rev = "15276bb0fcabf5fe4de4e58df3d579b5be0e9765";
          sha256 = "018np0qlk61l7mlv3xxx5cj1rax8f1vqrsrch3higsl25yydbv7v";
        };
      };
    };
    rds = {
      "3.7" = rec {
        version = "1.1.0";
        src = pkgs.fetchFromGitHub {
          owner = "bastibl";
          repo = "gr-rds";
          rev = "v${version}";
          sha256 = "0jkzchvw0ivcxsjhi1h0mf7k13araxf5m4wi5v9xdgqxvipjzqfy";
        };
      };
      "3.8" = rec {
        version = "3.8.0";
        src = pkgs.fetchFromGitHub {
          owner = "bastibl";
          repo = "gr-rds";
          rev = "v${version}";
          sha256 = "+yKLJu2bo7I2jkAiOdjvdhZwxFz9NFgTmzcLthH9Y5o=";
        };
      };
    };
    limesdr = {
      "3.7" = rec {
        version = "2.0.0";
        src = pkgs.fetchFromGitHub {
          owner = "myriadrf";
          repo = "gr-limesdr";
          rev = "v${version}";
          sha256 = "0ldqvfwl0gil89l9s31fjf9d7ki0dk572i8vna336igfaz348ypq";
        };
      };
      "3.8" = rec {
        version = "3.0.1";
        src = pkgs.fetchFromGitHub {
          owner = "myriadrf";
          repo = "gr-limesdr";
          rev = "v${version}";
          sha256 = "ffs+8TU0yr6IW1xZJ/abQ1CQWGZM+zYqPRJxy3ZvM9U=";
        };
      };
    };
  };
  # Here we strip down the ${ver} attribute and throwing a message if there is
  # no src suited for an incompatible 3.8/3.7 version.
  srcs = lib.mapAttrs
    (name: value:
      # Strip the sub attributes of the version.
      if builtins.hasAttr ver value then
        value.${ver}
      else
        throw "There is no src defined for gnuradio ${ver} package ${name}"
    ) knownSrcs
  ;
in srcs

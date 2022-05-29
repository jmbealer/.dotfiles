{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  (st.overrideAttrs (oldAttrs: rec {
    # ligatures dependency
    buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
    patches = [
      # ligatures patch
      (fetchpatch {
        url = "https://st.suckless.org/patches/ligatures/0.8.3/st-ligatures-20200430-0.8.3.diff";
        sha256 = "67b668c77677bfcaff42031e2656ce9cf173275e1dfd6f72587e8e8726298f09";
      })
    ];
    # version controlled config file
    # configFile = writeText "config.def.h" (builtins.readFile "${fetchFromGitHub { owner = "me"; repo = "my-custom-st-stuff"; rev = "1111222233334444"; sha256 = "11111111111111111111111111111111111"; }}/config.h");
    configFile = writeText "config.def.h" (builtins.readFile "${fetchFromGitHub { owner = "LukeSmithxyz"; repo = "st"; rev = "8ab3d03681479263a11b05f7f1b53157f61e8c3b"; sha256 = "1brwnyi1hr56840cdx0qw2y19hpr0haw4la9n0rqdn0r2chl8vag"; }}/config.h");
    postPatch = oldAttrs.postPatch ++ ''cp ${configFile} config.def.h'';
  }))
];
}

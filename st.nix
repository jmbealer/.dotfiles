{ config, lib, pkgs, ... }:

{
environment.systemPackages = with pkgs; [
  (st.overrideAttrs (oldAttrs: rec {
    buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
    patches = [
      (fetchpatch {
        url = "https://st.suckless.org/patches/ligatures/0.8.3/st-ligatures-20200430-0.8.3.diff";
        sha256 = "02cg54k8g3kyb1r6zz8xbqkp7wcwrrb2c7h38bzwmgvpfv3nidk7";
      })
    ];
    # Using a local file
    configFile = writeText "config.def.h" (builtins.readFile ./st/config.def.h);
    # Or one pulled from GitHub
    # configFile = writeText "config.def.h" (builtins.readFile "${fetchFromGitHub { owner = "LukeSmithxyz"; repo = "st"; rev = "8ab3d03681479263a11b05f7f1b53157f61e8c3b"; sha256 = "1brwnyi1hr56840cdx0qw2y19hpr0haw4la9n0rqdn0r2chl8vag"; }}/config.h");
    postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
  }))
];
}

{ config, lib, pkgs, ... }:

{
environment.systemPackages = with pkgs; [
  (dmenu.overrideAttrs (oldAttrs: rec {
    # buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
    patches = [
      #(fetchpatch {
      (fetchurl {
        url = "https://tools.suckless.org/dmenu/patches/center/dmenu-center-20200111-8cd37e1.diff";
        #sha256 = "0x7jc1m0138p7vfa955jmfhhyc317y0wbl8cxasr6cfpq8nq1qsg";
        hash = "sha256-dpiuLno7EE8VyZiDegD1CSdbqaRIQTzMg4aEJFiEQTQ=";
      })
    ];
    # Using a local file
    configFile = writeText "config.def.h" (builtins.readFile ./dmenu/config.def.h);
    # Or one pulled from GitHub
    # configFile = writeText "config.def.h" (builtins.readFile "${fetchFromGitHub { owner = "LukeSmithxyz"; repo = "st"; rev = "8ab3d03681479263a11b05f7f1b53157f61e8c3b"; sha256 = "1brwnyi1hr56840cdx0qw2y19hpr0haw4la9n0rqdn0r2chl8vag"; }}/config.h");
    postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
  }))
];
}

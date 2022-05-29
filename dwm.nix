{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
  (self: super: {
    dwm = super.dwm.overrideAttrs (oldAttrs: rec {
      patches = [
        # ./path/to/my-dwm-patch.patch
        ];
      configFile = super.writeText "config.h" (builtins.readFile ./dwm/config.def.h);
      postPatch = oldAttrs.postPatch or "" + "\necho 'Using own config file...'\n cp ${configFile} config.def.h";
      });
    # })
    st = super.st.overrideAttrs (oldAttrs: rec {
      buildInputs = oldAttrs.buildInputs ++ [ super.harfbuzz ];
      patches = [
        # ./path/to/my-dwm-patch.patch
      (super.fetchpatch {
        url = "https://st.suckless.org/patches/ligatures/0.8.3/st-ligatures-20200430-0.8.3.diff";
        sha256 = "02cg54k8g3kyb1r6zz8xbqkp7wcwrrb2c7h38bzwmgvpfv3nidk7";
      })
      ];
      configFile = super.writeText "config.h" (builtins.readFile ./st/config.def.h);
      postPatch = "${oldAttrs.postPatch}\ncp ${configFile} config.def.h\n";
      });
    })
  ];

}

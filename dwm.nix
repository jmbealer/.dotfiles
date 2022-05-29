{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
  (self: super: {
    dwm = super.dwm.overrideAttrs (oldAttrs: rec {
      patches = [
        # ./path/to/my-dwm-patch.patch
        (super.fetchpatch {
          url = "https://dwm.suckless.org/patches/centeredmaster/dwm-centeredmaster-20160719-56a31dc.diff";
          sha256 = "0naqj1yk28y61mlf6qajp7xm9hdvl8wnr1z63s6rfgydc2zdi4q1";
        })
        (super.fetchpatch {
          url = "https://dwm.suckless.org/patches/attachasideandbelow/dwm-attachasideandbelow-20200702-f04cac6.diff";
          sha256 = "0qgqlm5kplf2whw7zk0r9bksynb2fp9zrv1c9dpc6bm6c97b2p1s";
        })
        # (super.fetchpatch {
          # url = "https://dwm.suckless.org/patches/flextile/dwm-flextile-20210722-138b405.diff";
          # sha256 = "005f2j38dkygc15c8531i4b0ixjxy1a9bl6a3wa0ac570ikhi9lg";
        # })
        (super.fetchpatch {
          url = "https://dwm.suckless.org/patches/alpha/dwm-alpha-20201019-61bb8b2.diff";
          sha256 = "0qymdjh7b2smbv37nrh0ifk7snm07y4hhw7yiizh6kp2kik46392";
        })
        # (super.fetchpatch {
          # url = "https://dwm.suckless.org/patches/cyclelayouts/dwm-cyclelayouts-20180524-6.2.diff";
          # sha256 = "1ijslwbfmmznv4m5hadra8jcrds4zwky2m98d7cg8zdz3s9rva4q";
        # })
        (super.fetchpatch {
          url =  "https://dwm.suckless.org/patches/movethrow/dwm-movethrow-6.2.diff";
          sha256 =  "0gv1b8f9b6y978l5ybzf57dsx77mrh01lgalx03153hga447msn2";
        })
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

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
					hash = "sha256-p4hbx5oSLiEhRKX4PBS3RJL+qnVA/KD+GOH/WXOv51k=";
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
      src = super.fetchFromGitHub {
      owner = "LukeSmithxyz";
      repo = "st";
      rev = "8ab3d03681479263a11b05f7f1b53157f61e8c3b";
      sha256 = "1brwnyi1hr56840cdx0qw2y19hpr0haw4la9n0rqdn0r2chl8vag";
    };
    # Make sure you include whatever dependencies the fork needs to build properly!
    # buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];

      buildInputs = oldAttrs.buildInputs ++ [ super.harfbuzz ];
      # patches = [
      # (super.fetchpatch {
        # url = "https://st.suckless.org/patches/ligatures/0.8.3/st-ligatures-20200430-0.8.3.diff";
        # sha256 = "02cg54k8g3kyb1r6zz8xbqkp7wcwrrb2c7h38bzwmgvpfv3nidk7";
        # url = "https://st.suckless.org/patches/ligatures/0.8.4/st-ligatures-alpha-scrollback-20210824-0.8.4.diff";
        # sha256 = "1bkyx9aif541ps2hd7yxgsn9qmq77rgb7pjshfkj65wgn4rkk8fv";
      # })
      # (super.fetchpatch {
        # url = "https://st.suckless.org/patches/alpha/st-alpha-20220206-0.8.5.diff";
        # sha256 = "10gvwnpbjw49212k25pddji08f4flal0g9rkwpvkay56w8y81r22";
      # })
      # (super.fetchpatch {
        # url = "https://st.suckless.org/patches/alpha_focus_highlight/st-focus-20200731-patch_alpha.diff";
        # sha256 = "1lm02r9zyhdzds7nqh15qnmskcnj20fyxc45f5wnvb1mipb84hmj";
      # })
      # (super.fetchpatch {
        # url = "https://st.suckless.org/patches/blinking_cursor/st-blinking_cursor-20211116-2f6e597.diff";
        # sha256 = "0nyzaq3wxj5vjpl781v9yagqk5r0maxxa31miczdr915pr6wwqhv";
      # })
      # (super.fetchpatch {
        # url = "https://st.suckless.org/patches/scrollback/st-scrollback-ringbuffer-0.8.5.diff";
        # sha256 = "0xxwgkgpzc7s8ad0pgcwhm5hqyh2wy56a9yrxid68xm0np2g6m5h";
      # })
      # ];
      # configFile = super.writeText "config.h" (builtins.readFile ./st/config.def.h);
      # postPatch = "${oldAttrs.postPatch}\ncp ${configFile} config.def.h\n";
      # });
    # })
    });
  }
  )];

}

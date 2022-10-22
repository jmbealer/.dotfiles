{ config, lib, pkgs, ... }:

{
environment.systemPackages = with pkgs; [
  (st.overrideAttrs (oldAttrs: rec {
    buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
    patches = [
      (fetchpatch {
        # url = "https://st.suckless.org/patches/ligatures/0.8.3/st-ligatures-20200430-0.8.3.diff";
        # sha256 = "02cg54k8g3kyb1r6zz8xbqkp7wcwrrb2c7h38bzwmgvpfv3nidk7";
        url = "https://st.suckless.org/patches/ligatures/0.8.4/st-ligatures-alpha-scrollback-20210824-0.8.4.diff";
        sha256 = "1bkyx9aif541ps2hd7yxgsn9qmq77rgb7pjshfkj65wgn4rkk8fv";
      })
      (fetchpatch {
        url = "https://st.suckless.org/patches/alpha/st-alpha-20220206-0.8.5.diff";
        sha256 = "10gvwnpbjw49212k25pddji08f4flal0g9rkwpvkay56w8y81r22";
      })
      (fetchpatch {
        url = "https://st.suckless.org/patches/alpha_focus_highlight/st-focus-20200731-patch_alpha.diff";
        sha256 = "1lm02r9zyhdzds7nqh15qnmskcnj20fyxc45f5wnvb1mipb84hmj";
      })
      (fetchpatch {
        url = "https://st.suckless.org/patches/blinking_cursor/st-blinking_cursor-20211116-2f6e597.diff";
        sha256 = "0nyzaq3wxj5vjpl781v9yagqk5r0maxxa31miczdr915pr6wwqhv";
      })
      (fetchpatch {
        url = "https://st.suckless.org/patches/scrollback/st-scrollback-ringbuffer-0.8.5.diff";
        sha256 = "0xxwgkgpzc7s8ad0pgcwhm5hqyh2wy56a9yrxid68xm0np2g6m5h";
      })
    ];
    # Using a local file
    configFile = writeText "config.def.h" (builtins.readFile ./st/config.def.h);
    # Or one pulled from GitHub
    postPatch = "${oldAttrs.postPatch}\n cp ${configFile} config.def.h";
  }))
];
}

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  # User definitions and user-scoped settings shared across machines.

  # Users
  users.users."cipher" = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "input" "video" "backlight" "system76" "jackaudio"];
    packages = with pkgs; [tree];
  };

  # Autologin into the desktop session
  services.getty.autologinUser = "cipher";

  # Secrets (SOPS) — user-scoped: the age key lives in the user's home
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/cipher/.config/sops/age/keys.txt";
    secrets.msmtp-password = {
      owner = config.users.users."cipher".name;
      neededForUsers = true;
    };
  };
}

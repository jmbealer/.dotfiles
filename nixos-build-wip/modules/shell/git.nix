# Git

{

  programs.git = {
    enable = true;
    userName = "Justin Bealer";
    userEmail = "jmbealer11@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.ff = "only";
      url."https://github.com/".insteadOf = "git://github.com";
    };
  };

}


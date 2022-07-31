# modules/dev/python.nix --- https://godotengine.org/
#
# Python's ecosystem repulses me. The list of environment "managers" exhausts
# me. The Py2->3 transition make trainwrecks jealous. But SciPy, NumPy, iPython
# and Jupyter can have my babies. Every single one.

{ config, options, lib, pkgs, my, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.python;
in {
  options.modules.dev.python = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        # python37
        python3Full
        python39Packages.pip
        python39Packages.pip-tools
        # python37Packages.pip
        # python37Packages.ipython
        # python37Packages.black
        python37Packages.setuptools
        # pylint not working
        # python37Packages.pylint
        # python37Packages.poetry
        python39Packages.beautifulsoup4
        python39Packages.decorator
        python39Packages.distro
        python39Packages.flask
        python39Packages.flask-cors
        python39Packages.jsonschema
        python39Packages.markdown
        python39Packages.orjson
        python39Packages.protobuf
        python39Packages.pyaudio
        python39Packages.pyqtwebengine
        # python39Packages.pyqt6-webengine
        python39Packages.pysocks
        python39Packages.requests
        python39Packages.send2trash
        python39Packages.waitress
        python39Packages.wheel
      ];

      environment.shellAliases = {
        py     = "python";
        py2    = "python2";
        py3    = "python3";
        po     = "poetry";
        ipy    = "ipython --no-banner";
        ipylab = "ipython --pylab=qt5 --no-banner";
      };
    })

    (mkIf cfg.xdg.enable {
      env.IPYTHONDIR      = "$XDG_CONFIG_HOME/ipython";
      env.PIP_CONFIG_FILE = "$XDG_CONFIG_HOME/pip/pip.conf";
      env.PIP_LOG_FILE    = "$XDG_DATA_HOME/pip/log";
      env.PYLINTHOME      = "$XDG_DATA_HOME/pylint";
      env.PYLINTRC        = "$XDG_CONFIG_HOME/pylint/pylintrc";
      env.PYTHONSTARTUP   = "$XDG_CONFIG_HOME/python/pythonrc";
      env.PYTHON_EGG_CACHE = "$XDG_CACHE_HOME/python-eggs";
      env.JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    })
  ];
}

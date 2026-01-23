{ pkgs, ... }:

let envars = {
  EDITOR = "nvim";
  VISUAL = "nvim";
};
in
{
  home.sessionVariables = envars;

  systemd.user.sessionVariables = envars;
}

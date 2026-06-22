{pkgs, ...}: let
  windowpin = pkgs.writeShellApplication {
    name = "windowpin";
    text = ''
      # enable float
      WinFloat=$(hyprctl -j clients | jq '.[] | select(.focusHistoryID == 0) | .floating')
      WinPinned=$(hyprctl -j clients | jq '.[] | select(.focusHistoryID == 0) | .pinned')

      if [ "''${WinFloat}" == "false" ] && [ "''${WinPinned}" == "false" ] ; then
        hyprctl dispatch 'hl.dsp.window.float({action=toggle, window=activewindow})'
      fi

      # toggle pin
      hyprctl dispatch 'hl.dsp.window.pin({action=toggle, window=active})'

      # disable float
      WinFloat=$(hyprctl -j clients | jq '.[] | select(.focusHistoryID == 0) | .floating')
      WinPinned=$(hyprctl -j clients | jq '.[] | select(.focusHistoryID == 0) | .pinned')

      if [ "''${WinFloat}" == "true" ] && [ "''${WinPinned}" == "false" ] ; then
        hyprctl dispatch 'hl.dsp.window.float({action=toggle, window=activewindow})'
      fi

    '';
  };
in {
  home.packages = [windowpin];
}

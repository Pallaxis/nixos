{pkgs, ...}: let
  brightness = pkgs.writeShellApplication {
    name = "brightness";
    runtimeInputs = [pkgs.brightnessctl pkgs.ddcutil pkgs.dunst];
    text = ''
      dim_monitors() {
          exit 0 # disabling for now
          # Set monitor backlight to minimum, avoid 0 on OLED monitor.
          # brightnessctl -s set 10
          #
          # if [ ! -d "$XDG_CACHE_HOME"/monitor-save/ ]; then
          #     mkdir "$XDG_CACHE_HOME"/monitor-save/
          # fi
          # # Save brightness, then set to 10
          # ddcutil getvcp 0x10 | awk '{print $9}' | tr -d ',' > "$XDG_CACHE_HOME"/monitor-save/value
          # ddcutil setvcp 0x10 10
      }

      restore_brightness(){
          exit 0 # disabling for now
          # brightnessctl -r
          #
          # previous=$(cat "$XDG_CACHE_HOME"/monitor-save/value)
          # sleep 3
          # ddcutil setvcp 0x10 "$previous"
      }

      increase_brightness(){
        local output=""
        output=$(brightnessctl set 5%+ | awk '/Current/{print $4}' | tr -d '()')
        # dunstify -u low -h string:x-dunst-stack-tag:brightness -h int:value:"$output" "Brightness: ''${output}"
      }

      decrease_brightness(){
        local output=""
        output=$(brightnessctl set 5%- | awk '/Current/{print $4}' | tr -d '()')
        # dunstify -u low -h string:x-dunst-stack-tag:brightness -h int:value:"$output" "Brightness: ''${output}"
      }

      # Check if the first argument is supplied and if the function exists
      if [ -n "$1" ] && declare -f "$1" > /dev/null; then
          "$1"
      else
          echo "Function '$1' does not exist or no function name provided."
      fi

    '';
  };
in {
  home.packages = [brightness];
}

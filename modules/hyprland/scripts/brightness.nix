{pkgs, ...}: let
  brightness = pkgs.writeShellApplication {
    name = "brightness";
    runtimeInputs = [pkgs.brightnessctl pkgs.ddcutil pkgs.dunst];
    text = ''
      has_brightnessctl=false
      has_ddcutil=false

      brightnessctl g >/dev/null 2>&1 && has_brightnessctl=true
      ddcutil getvcp 0x10 >/dev/null 2>&1 && has_ddcutil=true

      brightnessctl_slow_transition() {
        local start=$1
        local end=$2
        local step=$(( start < end ? 1 : -1 ))

        local i=$start
        while (( i != end )); do
          brightnessctl set "''${i}%"
          sleep 0.01
          (( i += step ))
        done

        brightnessctl set "''${end}%"
      }

      parse_brightnessctl_to_percentage() {
        max_value=$(brightnessctl m)
        current_value=$(brightnessctl g)
        echo $(( current_value * 100 / max_value ))
      }

      cache_path=/tmp/brightness-script-temp-value

      dim_monitors() {
        # Use brightnessctl current percent, falls back to ddcutil
        if $has_brightnessctl; then
          current_percentage=$(parse_brightnessctl_to_percentage)
        else
          current_percentage=$(ddcutil getvcp 0x10 | grep -oP 'current value =\s*\K\d+')
        fi

        echo "$current_percentage" > "$cache_path"

        # Then for both brightnessctl and ddcutil set value if the dev exists
        $has_brightnessctl && brightnessctl_slow_transition "$current_percentage" 20 &
        $has_ddcutil && ddcutil setvcp 0x10 20
        wait
      }

      restore_brightness(){
        # Use brightnessctl current percent, falls back to ddcutil
        if $has_brightnessctl; then
          current_percentage=$(parse_brightnessctl_to_percentage)
        else
          current_percentage=$(ddcutil getvcp 0x10 | grep -oP 'current value =\s*\K\d+')
        fi

        if [ ! -f "$cache_path" ]; then
          echo "Error: No cached brightness found. Restoring to 100%"
          $has_brightnessctl && brightnessctl_slow_transition "$current_percentage" 100 &
          $has_ddcutil && ddcutil setvcp 0x10 100
          wait
          exit 2
        fi

        read -r cached_brightness < "$cache_path"

        $has_brightnessctl && brightnessctl_slow_transition "$current_percentage" "$cached_brightness" &
        $has_ddcutil && ddcutil setvcp 0x10 "$cached_brightness"
        wait

        rm "$cache_path"
      }

      increase_brightness(){
        $has_brightnessctl && brightnessctl set 5%+
        $has_ddcutil && ddcutil setvcp 0x10 + 5
        wait
      }

      decrease_brightness(){
        $has_brightnessctl && brightnessctl set 5%-
        $has_ddcutil && ddcutil setvcp 0x10 - 5
        wait
      }

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

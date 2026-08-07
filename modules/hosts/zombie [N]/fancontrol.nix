{
  flake.modules.nixos.zombie = {pkgs, ...}: let
    setFanCurve = pkgs.writeShellScript "set-asus-fan-curve" ''
      set -euo pipefail

      # Find the ASUS custom fan curve hwmon device dynamically.
      hwmon=""

      for dir in /sys/class/hwmon/hwmon*; do
        if [ -r "$dir/name" ] && [ "$(cat "$dir/name")" = "asus_custom_fan_curve" ]; then
          hwmon="$dir"
          break
        fi
      done

      if [ -z "$hwmon" ]; then
        echo "asus_custom_fan_curve hwmon device not found" >&2
        exit 1
      fi

      # CPU fan (pwm1)
      cpu_temps=(63 67 72 76 79 82 85 88)
      cpu_pwms=(35 45 63 68 76 94 119 145)

      # GPU fan (pwm2)
      gpu_temps=(60 63 66 69 72 75 77 79)
      gpu_pwms=(22 28 45 51 73 94 117 140)

      for i in ''${!cpu_temps[@]}; do
        n=$((i + 1))
        echo "''${cpu_temps[$i]}" > "$hwmon/pwm1_auto_point''${n}_temp"
        echo "''${cpu_pwms[$i]}"  > "$hwmon/pwm1_auto_point''${n}_pwm"
      done

      for i in ''${!gpu_temps[@]}; do
        n=$((i + 1))
        echo "''${gpu_temps[$i]}" > "$hwmon/pwm2_auto_point''${n}_temp"
        echo "''${gpu_pwms[$i]}"  > "$hwmon/pwm2_auto_point''${n}_pwm"
      done

      # Keep the EC in automatic fan-curve mode.
      echo 2 > "$hwmon/pwm1_enable"
      echo 2 > "$hwmon/pwm2_enable"
    '';
  in {
    systemd.services.asus-fan-curve = {
      description = "Configure ASUS fan curves";
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = setFanCurve;
      };
    };
  };
}

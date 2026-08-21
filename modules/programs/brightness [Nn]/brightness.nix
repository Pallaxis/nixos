{inputs, ...}: {
  flake.modules.nixos.brightness = {config, ...}: {
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.brightness
    ];

    hardware.i2c.enable = true;
    users.users."${config.systemConstants.username}".extraGroups = ["i2c"];
  };

  flake.modules.homeManager.brightness = {pkgs, ...}: {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "brightness";
        runtimeInputs = with pkgs; [brightnessctl coreutils gawk dunst];
        text = ''
          dim_monitors() {
              exit 0 # disabling for now
          }

          restore_brightness(){
              exit 0 # disabling for now
          }

          increase_brightness(){
            local output=""
            output=$(brightnessctl set 5%+ | awk '/Current/{print $4}' | tr -d '()')
            dunstify -u low -h string:x-dunst-stack-tag:brightness -h int:value:"$output" "Brightness: ''${output}"
          }

          decrease_brightness(){
            local output=""
            output=$(brightnessctl set 5%- | awk '/Current/{print $4}' | tr -d '()')
            dunstify -u low -h string:x-dunst-stack-tag:brightness -h int:value:"$output" "Brightness: ''${output}"
          }

          # Check if the first argument is supplied and if the function exists
          if [ -n "$1" ] && declare -f "$1" > /dev/null; then
              "$1"
          else
              echo "Function '$1' does not exist or no function name provided."
          fi
        '';
      })
    ];
  };
}

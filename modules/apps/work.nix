{ pkgs, ... }

{
  environment.systemPackages = with pkgs; [
    ansible
    ansible-core
    audacity
    chromium
    ddcutil
    dpkg
    intel-ucode
    krita
    openbsd-netcat
    tio
  ]
}

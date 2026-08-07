{
  flake.modules.nixos.office = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # ansible
      # ansible-core
      # audacity
      # dpkg
      # krita
      # openbsd-netcat
      libreoffice-fresh
      chromium
      gimp
      ffmpeg-full
      slack
      (tio.overrideAttrs (oldAttrs: {
        src = fetchFromGitHub {
          owner = "tio";
          repo = "tio";
          rev = "6fb3a64ba234cc255f9637ba938cf0c01e132e4a";
          sha256 = "mM8/2ozsXXKAhfTdf4+4f/ZBmhguS4D76zCfvF1VQC0=";
        };
      }))
    ];
  };
}

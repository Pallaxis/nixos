{
  flake.modules.nixos.work-packages = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      # ansible
      # ansible-core
      chromium
      ddcutil
      ffmpeg-full
      gimp
      libreoffice-fresh
      slack
      # Overrides tio version as they haven't had a release in a while
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

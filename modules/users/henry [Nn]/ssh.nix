let
  username = "henry";
in {
  flake.modules.nixos."${username}" = {
    users.users."${username}".openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTC9Is0+rTNgKa6cs0dR6ZX/IUUU3bHWuV8wzBAHVss pallaxis@night"
    ];
  };
}

{
  flake.modules.generic.systemConstants = {lib, ...}: {
    options.systemConstants = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = {};
    };

    config.systemConstants = {
      # adminEmail = "admin@test.org";

      # iPhoneIdSyncthing = "UBH4QQR-EFVPO6H-TJTENLD-K7PSSAS-34KPRWJ-MNJ2CQY-65H3IN7-4633XAQ";
    };
  };
}

{inputs, ...}: {
  config.flake.factory.diskoBtrfsLuks = {
    device,
    swapSize,
  }: let
    btrfsMountOptions = [
      "compress=zstd"
      "noatime"
    ];

    subvolumes = {
      "/root" = {
        mountpoint = "/";
        mountOptions = btrfsMountOptions;
      };

      "/home" = {
        mountpoint = "/home";
        mountOptions = btrfsMountOptions;
      };

      "/nix" = {
        mountpoint = "/nix";
        mountOptions = btrfsMountOptions;
      };

      "/swap" = {
        mountpoint = "/.swapvol";
        swap.swapfile.size = swapSize;
      };
    };

    btrfsContent = {
      type = "btrfs";
      extraArgs = ["-f"];
      inherit subvolumes;
    };

    luksContent = {
      type = "luks";
      name = "nixos-root";
      settings = {
        allowDiscards = true;
      };
      content = btrfsContent;
    };

    espPartition = {
      size = "1024M";
      type = "EF00";
      content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/boot";
        mountOptions = ["umask=0077"];
      };
    };

    partitions = {
      ESP = espPartition;

      luks = {
        size = "100%";
        content = luksContent;
      };
    };

    gptContent = {
      type = "gpt";
      inherit partitions;
    };
  in {
    imports = [
      inputs.disko.nixosModules.disko
    ];

    disko.devices.disk.main = {
      type = "disk";
      inherit device;
      content = gptContent;
    };
  };
}

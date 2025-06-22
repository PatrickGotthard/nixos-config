{ config, pkgs, ... }:

{

  system = {
    stateVersion = "25.05";
  };

  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config = {
      allowUnfree = true;
    };
  };

  boot = {
    initrd = {
      availableKernelModules = [
        "ata_piix" 
        "sd_mod" 
        "sr_mod" 
        "uhci_hcd" 
        "virtio_pci" 
        "virtio_scsi" 
      ];
    };
    kernelModules = [
      "kvm-amd" 
    ];
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  };

  networking = {
    hostName = "k3s";
    domain = "internal";
    interfaces = {
      ens18 = {
        ipv4 = {
          addresses = [
            { 
              address = "192.168.10.8"; 
              prefixLength = 24; 
            }
          ];
        };
      };
    };
    defaultGateway = "192.168.10.2";
    nameservers = [
      "192.168.10.3"
      "192.168.10.4"
    ];
  };

  time = {
    timeZone = "Europe/Berlin";
  };

  i18n = {
    defaultLocale = "de_DE.UTF-8";
  };

  console = {
    keyMap = "de-latin1-nodeadkeys";
  };

  services = {

    chrony = {
      enable = true;
    };

    k3s = {
      enable = true;
    };

    openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "prohibit-password";
          PasswordAuthentication  = false;
        };
    };

    qemuGuest = {
      enable = true;
    };

  };

  users = {
    users = {
      root = {
        openssh = {
          authorizedKeys = {
            keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMcfSzDzjjPUhI3fJItqQ+oCeEFnM86vAqs/wghFwRBn patrick"
            ];
          };
        };
      };
    };
  };

}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./desktop.hardware.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/run/media/rakan/windows" = {
    device = "/dev/nvme0n1p3";
    label = "Windows";
    fsType = "ntfs";
    options = [ "rw" "uid=1000" ];
  };
  fileSystems."/run/media/rakan/sd1" = {
    device = "/dev/sda";
    fsType = "auto";
    label = "SD1";
    options = [ "defaults" "user" "rw" "auto" ];
  };

  networking = {
    hostName = "nixos"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
    # Enable networking
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Amman";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;
  
      # Configure keymap in X11
      layout = "us,ara";
      xkbVariant = ",mac";
      xkbOptions = "grp:alt_space_toggle";

      videoDrivers = [ "nvidia" ];

      # Enable touchpad support (enabled default in most desktopManager).
      # libinput.enable = true;
 
      desktopManager.xfce.enable = true;
       
      displayManager = {
        lightdm = {
          enable = true;
          greeters.gtk.extraConfig = "xft-dpi=72";
        };
        defaultSession = "none+awesome";
      };

      windowManager.awesome = {
 	      enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks
          luadbi-mysql
        ];
      };
    };
 
    plex = {
      enable = true;
      user = "rakan";
      openFirewall = true;
    };
 
    # Enable CUPS to print documents.
    printing.enable = true;
  
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;
  
      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    }; 
    
    blueman.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
    pcscd.enable = true;
  };

  # Enable sound with pipewire.
  sound.enable = true;

  hardware = {
    bluetooth.enable = true;
    keyboard.uhk.enable = true;
    keyboard.zsa.enable = true;
    pulseaudio.enable = false;
    opengl.enable = true;
    nvidia.modesetting.enable = true;
    ledger.enable = true;
  };

  security.polkit.enable = true;
  security.rtkit.enable = true;
  security.sudo.extraRules= [
    {
      users = [ "rakan" ];
      commands = [{
        command = "ALL" ;
        options= [ "NOPASSWD" ];
      }];
    }
  ];

  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      hack-font
      fira-code
      ubuntu_font_family
      liberation_ttf
      inconsolata
      noto-fonts
      noto-fonts-emoji
      iosevka
      (nerdfonts.override { fonts = [ "Hack" "Iosevka" ]; })
    ];
  };
  
  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rakan = {
    isNormalUser = true;
    description = "Rakan Alhneiti";
    extraGroups = [ "audio" "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-24.8.6"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
     direnv
     polkit_gnome
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.zsh.enable = true;
  programs.ssh.startAgent = true;
  programs.file-roller.enable = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

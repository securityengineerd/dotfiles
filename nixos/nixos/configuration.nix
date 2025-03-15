# file: /etc/nixos/configuration.nix #
# author: Joshua Marcum <josh.marcum@icloud.com>

{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # nix configuration
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # environment configuration
  environment.variables.EDITOR = "nvim";

  # boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    supportedFilesystems = [ "zfs" ];
    zfs.requestEncryptionCredentials = true;

  };

  # networking configuration
  networking = {
    hostId = "00FEA10E";
    hostName = "nixos-laptop"; 
    networkmanager.enable = true;
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;

  };

  # virtualisation configuration
  virtualisation.docker.enable = true;
  
  # service configuration
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    flatpak.enable = true;
    openssh.enable = true;
    xserver.enable = true;
    libinput.enable = true;
  
  };

  # package configuration
  programs = {
    firefox.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    mtr.enable = true;
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
    zsh.enable = true;
  
  };

  # console configuration
  console = {
    font = "gr928-8x16-thin";
    useXkbConfig = true; # use xkb.options in tty.

  };

  # user configuration
  users = {  
    users.josh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "audio" "video" "docker" "render" "networkmanager" ]; 
    packages = with pkgs; [
      curl
      direnv
      kitty
      nvm
      pyenv
      tree
      st
      wget
    ];
    };
  };

  # system packages - install
  environment.systemPackages = with pkgs; [
    chromium
    docker
    git
    grim
    mako
    neovim 
    pavucontrol
    slurp
    tmux
    waybar
    wget
    wl-clipboard
    wofi
  ];

  # system configuration - backup copy
  system.copySystemConfiguration = true;

  # NEVER change this value after the initial install!
  system.stateVersion = "24.11"; # Did you read the comment?

}






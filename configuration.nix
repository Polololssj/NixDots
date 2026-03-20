{ config, pkgs, inputs, ... }:

let
  terminal = "kitty";
  rebuild-script = pkgs.writeShellScriptBin "rebuild-system" ''
    cd /home/polololssj/dots/
    clear
    echo '=========================================='
    echo '  ❄️  DEBUT DU REBUILD'
    echo '=========================================='
    if sudo nixos-rebuild switch --flake .#nixos; then
        echo "✅ REBUILD REUSSI"
        echo ""
        echo "📦 Push des dotfiles sur GitHub..."
        ${pkgs.git}/bin/git add . 
        ${pkgs.git}/bin/git commit -m "update: ''$(date '+%Y-%m-%d %H:%M')" && ${pkgs.git}/bin/git push && echo "✅ GitHub à jour" || echo "⚠️  Rien à push"
    else
        echo "❌ ECHEC"
    fi
    echo "Appuie sur Entrée pour quitter."
    read
'';
in
{
  # ============================================================================
  # 1. IMPORTATIONS & SYSTÈME DE BASE
  # ============================================================================
  imports = [ 
    ./hardware-configuration.nix 
  ];

  system.stateVersion = "25.11";

  nix.nixPath = [ 
    "nixos-config=/home/polololssj/dots/configuration.nix"
    "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
  ];

  # ============================================================================
  # 2. BOOT & KERNEL 
  # ============================================================================
  boot.loader.limine.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ============================================================================
  # 3. RÉSEAU & LOCALISATION
  # ============================================================================
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "fr_BE.UTF-8";
  
  console.keyMap = "be-latin1";
  services.xserver.xkb = {
    layout = "be";
    variant = "";
  };

  # ============================================================================
  # 4. SERVICES SYSTÈME
  # ============================================================================
  services.displayManager.ly.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.printing.enable = true;

  services.blueman.enable = true;
  hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  settings = {
    General = {
      Experimental = true;
      FastConnectable = true;
    };
    Policy = {
      AutoEnable = true;
    };
    };
  };

  # ============================================================================
  # 5. UTILISATEURS & SÉCURITÉ
  # ============================================================================
  users.users.polololssj = {
    isNormalUser = true;
    description = "Patryk Kasprzak";
    extraGroups = [ "networkmanager" "wheel" "video" "docker" "vmware" "dialout" ];
    shell = pkgs.zsh;
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "cisco-packet-tracer-8.2.2"
    ];
  };

  # ============================================================================
  # 6. LOGICIELS & ENVIRONNEMENT
  # ============================================================================
  
  programs.niri.enable = true;
  virtualisation.vmware.host.enable = true;
  virtualisation.docker.enable = true;

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  virtualisation.docker.rootless = {
  enable = true;
  setSocketVariable = true;
  };

  environment.systemPackages = with pkgs; [
    
    rebuild-script
    (makeDesktopItem {
      name = "Rebuild Nix";
      desktopName = "rebuild Nix";
      exec = "rebuild-system";
      icon = "system-software-update";
      type = "Application";
      categories = [ "System" ];
    })
    

    xwayland-satellite 
    fuzzel
    alacritty
    kitty
    vesktop
    vscodium
    htop
    fastfetch
    swaybg
    winboat
    ciscoPacketTracer8
    docker-compose
    mako
    gnome-themes-extra
    waybar
    git
    obsidian
    teams-for-linux
    gh
    putty
    powershell
    python3
    thonny
    
    inputs.zen-browser.packages.${pkgs.system}.default
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji
  ];

  environment.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
    XCURSOR_SIZE = "16";
  };
  
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

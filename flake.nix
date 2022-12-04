{
  inputs = { nixpkgs.url = "github:nixos/nixpkgs/22.11"; };
  outputs = { self, nixpkgs }: {

    nixosModules = let
      base = { config, pkgs }: {
        time.timeZone = "America/New_York";

        boot.cleanTmpDir = true;
        nix.settings.trusted-users = [ "root" "@wheel" ];
        nix.settings.substituters =
          [ "https://ogre.mad.hubns.net/cache" "https://cache.nixos.org" ];
        nix.settings.trusted-public-keys =
          [ "mad.hubns.net:u+Hmwl+Uffo+TMLr4PMzQ2+rsvHFXoPOR1RZrzHDqoQ=" ];
        nix.settings.experimental-features =  [ "nix-command" "recursive-nix" "flakes" ];

        programs.mtr.enable = true;

        nix.optimise.automatic = true;

        networking.firewall.trustedInterfaces = [ "tailscale0" ];
        services.openssh.extraConfig = ''
          StreamLocalBindUnlink yes
        '';
        programs.mosh.enable = true;

        environment.systemPackages = with pkgs; [
          bc
          bind
          binutils
          curl
          direnv
          file
          gist
          git
          gitAndTools.git-absorb
          lazygit
          gnupg
          htop
          httping
          iperf
          jp
          jq
          ripgrep
          lsof
          zstd
          mbuffer
          netcat-openbsd
          nmap
          psmisc
          rsync
          screen
          silver-searcher
          tcpdump
          tmux
          tree
          unzip
          usbutils
          wget
          whois
          zip
        ];

        environment.variables = { EDITOR = "vim"; };
        nixpkgs.config.allowUnfree = true;
        programs.vim.defaultEditor = true;
        programs.vim.package = pkgs.madvim;

        programs.ssh.startAgent = true;

        programs.zsh.enable = true;

        services.openssh.enable = true;

        security.sudo.enable = true;
        security.sudo.wheelNeedsPassword = false;

        users.mutableUsers = true;
        users.defaultUserShell = "${pkgs.zsh}/bin/zsh";
        users.extraUsers.root.openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZqbJ13uyuV0efgGf5gq+Vc2h/YVznh+wMAgdAdF8qV cransom@caseys-imac.mad.hubns.net"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMhki/fDlBfh/CJkkf1ruF0t5s9gklrLnHeGFldZDCM cransom@blink"
        ];

        users.extraUsers.cransom = {
          isNormalUser = true;
          createHome = true;
          description = "casey ransom";
          extraGroups = [ "wheel" "networkmanager" ];
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZqbJ13uyuV0efgGf5gq+Vc2h/YVznh+wMAgdAdF8qV cransom@caseys-imac.mad.hubns.net"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMhki/fDlBfh/CJkkf1ruF0t5s9gklrLnHeGFldZDCM cransom@blink"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKVG3x7W7YYynwf9MkuiqjQoqNISaOGN5PBGi/0ICasy Shortcuts on cPhone"
          ];
        };

    };
    in {
      inherit base;
      default = base;
    };

  };
}

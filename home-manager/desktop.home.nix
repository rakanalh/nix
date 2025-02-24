# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: 
let 
  gpgPkg = config.programs.gpg.package;
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    inputs.nix-doom-emacs.hmModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
      # (final: prev: rec {
      #   nyxt = prev.nyxt.overrideAttrs (old: {
      #     version = "3.10.0";
      #     installPhase = ''
      #       gappsWrapperArgs+=(
      #         --set WEBKIT_DISABLE_SANDBOX_THIS_IS_DANGEROUS 1
      #       )
      #     '' + old.installPhase;
      #   });

      #   lispPackages = prev.lispPackages // {
      #     nyxt = prev.lispPackages.nyxt.overrideAttrs (old: rec {
      #       version = "3.10.0";
      #       src = prev.fetchFromGitHub {
      #         owner = "atlas-engineer";
      #         repo = "nyxt";
      #         rev = "${version}";
      #         sha256 = "";
      #       };
      #     });
      #   };
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      permittedInsecurePackages = [
        "electron-24.8.6"
        "electron-25.9.0"
        "adobe-reader-9.5.5"
      ];
    };
  };

  home = {
    username = "rakan";
    homeDirectory = "/home/rakan";
    file = {
      ".config/alacritty.yml".source = ./.config/alacritty.yml;
      ".config/ra-multiplex".source = ./.config/ra-multiplex;
      ".mozilla/native-messaging-hosts/ax.nd.profile_switcher_ff.json".source = ./.config/mozilla/ff-profile/ax.nd.profile_switcher_ff.json;
      ".config/awesome".source = (pkgs.fetchFromGitHub {
        owner = "rakanalh";
        repo = "awesome-config";
        rev = "566c3036a3c898634d6a395ed7223c742b7b56d1";
        sha256 = "sha256-EUUFPNGG5jbjj/3D8cpVOYf1VqSSEtGqWyP4NAORWXA=";
        fetchSubmodules = true;
      });
      ".Xresources".source = ./.config/Xresources;
      # ".password-store".source = (builtins.fetchGit {
      #   url = "ssh://git@github.com/rakanalh/password-store.git";
      #   ref = "master";
      # });
    };
    sessionVariablesExtra = ''
      export SSH_AUTH_SOCK="$(${gpgPkg}/bin/gpgconf --list-dirs agent-ssh-socket)"
      export PATH=$PATH:~/.cargo/bin
    '';
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    # Browser
    google-chrome
    unstable.vivaldi

    # Chat
    element-desktop
    discord
    slack
    tdesktop

    # Desktop
    adobe-reader
    i3lock-fancy
    ledger-live-desktop
    gnome.gnome-calculator
    uhk-agent
    qtpass
    transmission-gtk
    openra
    obsidian
    speedcrunch
    sublime3
    xfce.thunar
    xfce.tumbler

    # Fonts
    nerdfonts
    iosevka

    # Global Rust deps
    clang
    openssl
    openssl.dev
    pkg-config
    rustup

    # Dev tools
    go
    gopls
    jq
    nodejs
    ripgrep
    sccache
    silver-searcher
    sqlite
    wget
    unzip
    vagrant
    zip

    # Cli Apps
    awscli
    docker-compose
    htop
    neofetch
    pamixer
    noip
    wally-cli

    # Audio / Video
    mpv
    mpd
    vlc

    # Tools
    obs-studio
    pavucontrol
    rofi-pulse-select

    # Other
    webkitgtk
  ];

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };
  };

  programs = {
    # Enable home-manager
    home-manager.enable = true;

    alacritty.enable = true;
    doom-emacs = {
      enable = true;
      doomPrivateDir = ./.config/doom.d;
    };
    # Better 'cat'
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        pager = "less -FR";
      };
    };
    command-not-found = {
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    # Better 'ls'
    eza = {
      enable = true;
      enableAliases = true;
    };
    feh = {
      enable = true;
    };
    fzf.enable = true;
    firefox = {
      enable = true;
      profiles = {
        personal = {
          id = 0;
          isDefault = true;
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };

          userChrome = ''
            @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");

            #TabsToolbar {
              visibility: collapse;
            }

            #titlebar {
              display: none;
            }

            #sidebar-header {
              display: none;
            }
          '';
        };
        work = {
          id = 1;
          isDefault = false;
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };

          userChrome = ''
            @namespace url("http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul");

            #TabsToolbar {
              visibility: collapse;
            }

            #titlebar {
              display: none;
            }

            #sidebar-header {
              display: none;
            }
          '';
        };
      };
    };
    git = {
      enable = true;
      delta.enable = true;
      userName = "rakanalh";
      userEmail = "rakan.alhneiti@gmail.com";
      signing.signByDefault = true;
      signing.key = "E565B55AACE73E69DBAE87C89981A6DBFDC453AE";
      aliases = {
        lol = "log --graph --decorate --oneline --abbrev-commit";
        lola = "log --graph --decorate --oneline --abbrev-commit --all";
        hist =
          "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
      };
      extraConfig = {
        pull.ff = "only";
        merge.conflictstyle = "diff3";
      };
    };
    gpg = {
      enable = true;
      settings = {
        default-key = "BA80A7DBD120886D254C5854CBA62CDD373CF02E";
      };
    };
    neovim.enable = true;
    password-store = {
        enable = true;
        settings = {
          PASSWORD_STORE_DIR = "$HOME/.password-store";
        };
    };
    rofi = {
      enable = true;
      theme = "Arc-Dark";
      pass.enable = true;
      pass.extraConfig = ''
        AUTOTYPE_field='pass'
        help_color="#4872FF"
      '';
      plugins = [
        pkgs.rofi-calc
        pkgs.rofi-emoji
        pkgs.rofi-power-menu
        pkgs.rofi-pulse-select
      ];
    };
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = false;
        nix_shell = {
          disabled = false;
          impure_msg = "[shell](bold red)";
          pure_msg = "[shell](bold green)";
          format = "[☃️ \($name\)](bold blue) ";
        };
        aws = {
          disabled = true;
        };
        git_branch = {
          format = "$symbol\\[[$branch]($style)\\] ";
        };
        rust = {
          format = "\\[using [$symbol($version)]($style)\\] ";
        };
        python = {
          format = "\\[using [$symbol$pyenv_prefix($version \\((\($virtualenv\))\\))]($style)\\] ";
        };
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };

        package.disabled = false;
      };
    }; 
    tmux = {
      enable = true;
      prefix = "C-a";
      plugins = with pkgs; [
        tmuxPlugins.cpu
        tmuxPlugins.yank
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = "set -g @resurrect-processes 'vi vim nvim emacs man less more tail top htop irssi vagrant ssh mysql psql'";
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60' # minutes
          '';
        }
        {
          plugin = tmuxPlugins.copycat;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60' # minutes
          '';
        }
      ];
      extraConfig = ''
        set-window-option -g pane-base-index 1
        set -g base-index 1
        set -g mode-keys vi
        set -g detach-on-destroy off
        set -g history-limit 100000

        ## Mouse
        set -g mouse on
        set -g @scroll-speed-num-lines-per-scroll "0.5"

        ## Allow the arrow key to be used immediately after changing windows.
        set-option -g repeat-time 0

        ## Automatically set window title
        set-window-option -g automatic-rename on
        set-option -g set-titles on

        ## Window activity monitor
        setw -g monitor-activity on
        set -g visual-activity on

        # Keybindings
        ## New Shell
        bind-key Enter new "${pkgs.zsh}/bin/zsh"

        ## Easy clear history
        bind-key L clear-history

        ## Jump quickly into search
        bind-key / copy-mode \; send-key ?

        ## Set easier window split keys
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind _ split-window -fv -c "#{pane_current_path}"
        unbind '"'
        unbind %
        ## Windows
        bind c new-window -c "#{pane_current_path}"
        bind -n S-Left previous-window
        bind -n S-Right next-window

        ## Panes
        ### Movement
        bind k select-pane -U
        bind j select-pane -D
        bind l select-pane -R
        bind h select-pane -L
        bind u select-pane -t .-1 \;  resize-pane -Z
        bind o select-pane -t .+1 \;  resize-pane -Z

        ## Multi-Key sequences
        ### Resizing
        bind -T paneResize k resize-pane -U "10" \; switch-client -T paneResize
        bind -T paneResize j resize-pane -D "10" \; switch-client -T paneResize
        bind -T paneResize l resize-pane -R "10" \; switch-client -T paneResize
        bind -T paneResize h resize-pane -L "10" \; switch-client -T paneResize
        bind r switch-client -T paneResize

        ### Help
        bind -T helpKeys l list-keys
        bind -T kelpKeys r source-file ~/.tmux.conf \; display-message "tmux.conf reloaded."
        bind t switch-client -T helpKeys

        ## History
        bind -n C-k clear-history

        ## Mouse
        unbind -T copy-mode-vi MouseDragEnd1Pane
        ### Don't scroll down after yank
        bind-key -T copy-mode-vi y send-keys -X copy-pipe "xsel -ib" \; send-keys -X clear-selection
        bind-key -T copy-mode-vi Y send-keys -X copy-pipe-and-cancel "tmux paste-buffer"
        #bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
        #bind -n WheelDownPane select-pane -t= \; send-keys -M

        ######################
        ### DESIGN CHANGES ###
        ######################

        # panes
        set -g pane-border-style fg=black
        set -g pane-active-border-style fg=brightred

        ## Status bar design
        # status line
        set -g status-justify left
        set -g status-bg default
        set -g status-fg colour12
        set -g status-interval 2

        # messaging
        set -g message-style fg=black,bg=yellow
        set -g message-command-style fg=blue,bg=black

        #window mode
        setw -g mode-style bg=colour6,fg=colour0

        # window status
        setw -g window-status-format " #F#I:#W#F "
        setw -g window-status-current-format " #F#I:#W#F "
        setw -g window-status-format "#[fg=magenta]#[bg=black] #I #[bg=cyan]#[fg=colour8] #W "
        setw -g window-status-current-format "#[bg=brightmagenta]#[fg=colour8] #I #[fg=colour8]#[bg=colour14] #W "
        setw -g window-status-current-style bg=colour0,fg=colour11,dim
        setw -g window-status-style bg=green,fg=black,reverse

        # Info on left (I don't have a session display for now)
        set -g status-left ""

        # loud or quiet?
        set-option -g visual-activity off
        set-option -g visual-bell off
        set-option -g visual-silence off
        set-window-option -g monitor-activity off
        set-option -g bell-action none

        set -g default-terminal "screen-256color"

        # The modes {
        setw -g clock-mode-colour colour135
        setw -g mode-style fg=colour196,bg=colour238,bold

        # }
        # The panes {

        set -g pane-border-style bg=colour235,fg=colour238,
        set -g pane-active-border-style bg=colour236,fg=colour51

        # }
        # The statusbar {

        set -g status-position bottom
        set -g status-style bg=colour234,fg=colour137,dim
        set -g status-left ""
        set -g status-right '#[fg=color233,bg=color=245,bold] CPU: #{cpu_percentage} #[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '
        set -g status-right-length 50
        set -g status-left-length 20

        setw -g window-status-current-style fg=colour81,bg=colour238,bold
        setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '

        setw -g window-status-style fg=colour138,bg=colour235,none
        setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

        setw -g window-status-bell-style fg=colour255,bg=colour1,bold

        # }
        # The messages {

        set -g message-style fg=colour232,bg=colour166,bold
      '';
    };
    vscode.enable = true;
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh.enable = true;
      oh-my-zsh.theme = "fox";
      envExtra = ''
        PATH=''${PATH}:~/.cargo/bin
        RUSTC_WRAPPER=~/.cargo/bin/sccache
        WEBKIT_DISABLE_COMPOSITING_MODE=1
        PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig";

        bindkey -e
        bindkey '[C' forward-word
        bindkey '[D' backward-word
        bindkey \^U backward-kill-line
      '';
      shellAliases = {
        # exa
        #ls = "${pkgs.exa}/bin/exa";
        #ll = "${pkgs.exa}/bin/exa -l";
        #la = "${pkgs.exa}/bin/exa -a";
        #lt = "${pkgs.exa}/bin/exa --tree";
        #lla = "${pkgs.exa}/bin/exa -la";

        # git
        gs = "${pkgs.git}/bin/git status";

        # bat
        cat = "${pkgs.bat}/bin/bat";
      };
      plugins = [
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.5.0";
            sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
          };
        }
      ];
    };
  };
  
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
      sshKeys = [
        "BA80A7DBD120886D254C5854CBA62CDD373CF02E"
        "E565B55AACE73E69DBAE87C89981A6DBFDC453AE"
      ];
    };
    flameshot = {
      enable = true;
      settings = {
        General = {
          disabledTrayIcon = true;
          showStartupLaunchMessage = false;
        };
      };
    };
    udiskie = {
      enable = true;
      automount = true;
      notify = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

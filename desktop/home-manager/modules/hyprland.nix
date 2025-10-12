{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    settings = {
      "$terminal" = "kitty";
      "$fileManager" = "nemo";
      "$browser" = "librewolf";
      "$music" = "spotify"; # or whatever you use
      "$messenger" = "discord"; # or whatever you use
      "$passwordManager" = "keepassxc"; # or whatever you use
      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "QT_STYLE_OVERRIDE,kvantum"
        "SDL_VIDEODRIVER,wayland"
        "MOZ_ENABLE_WAYLAND,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        "OZONE_PLATFORM,wayland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XCOMPOSEFILE,~/.XCompose"
        "GDK_SCALE,2"
      ];

      # Monitor configuration
      monitor = [ ",preferred,auto,auto" ];

      # XWayland settings
      xwayland = { force_zero_scaling = true; };

      # Ecosystem settings
      ecosystem = { no_update_news = true; };

      # Autostart applications
      exec-once = [
        "uwsm app -- mako"
        "uwsm app -- waybar"
        "uwsm app -- swayosd-server"
      ];

      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        # "col.active_border" = "rgb(a89984)";
        # "col.inactive_border" = "rgba(595959aa)";
        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      # Decoration settings
      decoration = {
        rounding = 0;

        shadow = {
          enabled = true;
          range = 2;
          render_power = 3;
          # color = "rgba(1a1a1aee)";
        };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      # Animation settings
      animations = {
        enabled = true;

        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];

        animation = [
          "global,1,10,default"
          "border,1,5.39,easeOutQuint"
          "windows,1,4.79,easeOutQuint"
          "windowsIn,1,4.1,easeOutQuint,popin 87%"
          "windowsOut,1,1.49,linear,popin 87%"
          "fadeIn,1,1.73,almostLinear"
          "fadeOut,1,1.46,almostLinear"
          "fade,1,3.03,quick"
          "layers,1,3.81,easeOutQuint"
          "layersIn,1,4,easeOutQuint,fade"
          "layersOut,1,1.5,linear,fade"
          "fadeLayersIn,1,1.79,almostLinear"
          "fadeLayersOut,1,1.39,almostLinear"
          "workspaces,0,0,ease"
        ];
      };

      # Dwindle layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      # Master layout
      master = { new_status = "master"; };

      # Misc settings
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
      };

      # Cursor settings
      cursor = { hide_on_key_press = true; };

      # Input settings
      input = {
        kb_options = "compose:caps";
        repeat_rate = 40;
        repeat_delay = 300;
        numlock_by_default = true;

        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.4;
        };
      };

      # Window rules
      windowrule = [
        "suppressevent maximize,class:.*"
        "opacity 0.97 0.9,class:.*"
        "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
        "scrolltouchpad 1.5,class:(Alacritty|kitty)"
        "scrolltouchpad 0.2,class:com.mitchellh.ghostty"
      ];

      # Key bindings - General applications
      bind = [ "SUPER,SPACE,exec,rofi -show drun -show-icons" ];

      bindd = [
        "SUPER,return,exec,$terminal"
        "SUPER,F,exec,$fileManager"
        "SUPER,B,exec,$browser"
        "SUPER,M,exec,$music"
        "SUPER,N,exec,$terminal -e nvim"
        "SUPER,T,exec,$terminal -e btop"
        "SUPER,D,exec,$terminal -e lazydocker"
        "SUPER,G,exec,$messenger"
        "SUPER,O,exec,obsidian -disable-gpu"
        "SUPER,slash,exec,$passwordManager"

        # Tiling
        "SUPER,W,killactive,"
        "CTRL ALT,DELETE,exec,omarchy-cmd-close-all-windows"
        "SUPER,J,togglesplit,"
        "SUPER,P,pseudo,"
        "SUPER,V,togglefloating,"
        "SHIFT,F11,fullscreen,0"
        "ALT,F11,fullscreen,1"

        # Focus movement
        "SUPER,left,movefocus,l"
        "SUPER,right,movefocus,r"
        "SUPER,up,movefocus,u"
        "SUPER,down,movefocus,d"

        # Workspace switching
        "SUPER,code:10,workspace,1"
        "SUPER,code:11,workspace,2"
        "SUPER,code:12,workspace,3"
        "SUPER,code:13,workspace,4"
        "SUPER,code:14,workspace,5"
        "SUPER,code:15,workspace,6"
        "SUPER,code:16,workspace,7"
        "SUPER,code:17,workspace,8"
        "SUPER,code:18,workspace,9"
        "SUPER,code:19,workspace,10"

        # Move to workspace
        "SUPER SHIFT,code:10,movetoworkspace,1"
        "SUPER SHIFT,code:11,movetoworkspace,2"
        "SUPER SHIFT,code:12,movetoworkspace,3"
        "SUPER SHIFT,code:13,movetoworkspace,4"
        "SUPER SHIFT,code:14,movetoworkspace,5"
        "SUPER SHIFT,code:15,movetoworkspace,6"
        "SUPER SHIFT,code:16,movetoworkspace,7"
        "SUPER SHIFT,code:17,movetoworkspace,8"
        "SUPER SHIFT,code:18,movetoworkspace,9"
        "SUPER SHIFT,code:19,movetoworkspace,10"

        # Workspace navigation
        "SUPER,TAB,workspace,e+1"
        "SUPER SHIFT,TAB,workspace,e-1"
        "SUPER CTRL,TAB,workspace,previous"

        # Window swapping
        "SUPER SHIFT,left,swapwindow,l"
        "SUPER SHIFT,right,swapwindow,r"
        "SUPER SHIFT,up,swapwindow,u"
        "SUPER SHIFT,down,swapwindow,d"

        # Window cycling
        "ALT,Tab,cyclenext"
        "ALT SHIFT,Tab,cyclenext,prev"
        "ALT,Tab,bringactivetotop"
        "ALT SHIFT,Tab,bringactivetotop"

        # Window resizing
        "SUPER,code:20,resizeactive,-100 0"
        "SUPER,code:21,resizeactive,100 0"
        "SUPER SHIFT,code:20,resizeactive,0 -100"
        "SUPER SHIFT,code:21,resizeactive,0 100"

        # Mouse workspace scrolling
        "SUPER,mouse_down,workspace,e+1"
        "SUPER,mouse_up,workspace,e-1"

        # Utilities
        "SUPER ALT,SPACE,exec,omarchy-menu"
        "SUPER,ESCAPE,exec,omarchy-menu system"
        "SUPER,K,exec,omarchy-menu-keybindings"
        ",XF86Calculator,exec,gnome-calculator"

        # Aesthetics
        "SUPER SHIFT,SPACE,exec,omarchy-toggle-waybar"
        "SUPER CTRL,SPACE,exec,omarchy-theme-bg-next"
        "SUPER SHIFT CTRL,SPACE,exec,omarchy-menu theme"
        ''
          SUPER,BACKSPACE,exec,hyprctl dispatch setprop "address:$(hyprctl activewindow -j | jq -r '.address')" opaque toggle''

        # Notifications
        "SUPER,COMMA,exec,makoctl dismiss"
        "SUPER SHIFT,COMMA,exec,makoctl dismiss --all"
        ''
          SUPER CTRL,COMMA,exec,makoctl mode -t do-not-disturb && makoctl mode | grep -q 'do-not-disturb' && notify-send "Silenced notifications" || notify-send "Enabled notifications"''

        # Toggles
        "SUPER CTRL,I,exec,omarchy-toggle-idle"
        "SUPER CTRL,N,exec,omarchy-toggle-nightlight"

        # Apple Display brightness
        "CTRL,F1,exec,omarchy-cmd-apple-display-brightness -5000"
        "CTRL,F2,exec,omarchy-cmd-apple-display-brightness +5000"
        "SHIFT CTRL,F2,exec,omarchy-cmd-apple-display-brightness +60000"

        # Screenshots
        ",PRINT,exec,omarchy-cmd-screenshot"
        "SHIFT,PRINT,exec,omarchy-cmd-screenshot window"
        "CTRL,PRINT,exec,omarchy-cmd-screenshot output"

        # Screen recordings
        "ALT,PRINT,exec,omarchy-cmd-screenrecord region"
        "ALT SHIFT,PRINT,exec,omarchy-cmd-screenrecord region audio"
        "CTRL ALT,PRINT,exec,omarchy-cmd-screenrecord output"
        "CTRL ALT SHIFT,PRINT,exec,omarchy-cmd-screenrecord output audio"

        # Color picker
        "SUPER,PRINT,exec,pkill hyprpicker || hyprpicker -a"

        # File sharing
        "CTRL SUPER,S,exec,omarchy-menu share"
      ];

      bindld = [
        ",XF86PowerOff,exec,omarchy-menu system"
        ",XF86AudioNext,exec,$osdclient --playerctl next"
        ",XF86AudioPause,exec,$osdclient --playerctl play-pause"
        ",XF86AudioPlay,exec,$osdclient --playerctl play-pause"
        ",XF86AudioPrev,exec,$osdclient --playerctl previous"
        "SUPER,XF86AudioMute,exec,omarchy-cmd-audio-switch"
      ];

      bindeld = [
        ",XF86AudioRaiseVolume,exec,$osdclient --output-volume raise"
        ",XF86AudioLowerVolume,exec,$osdclient --output-volume lower"
        ",XF86AudioMute,exec,$osdclient --output-volume mute-toggle"
        ",XF86AudioMicMute,exec,$osdclient --input-volume mute-toggle"
        ",XF86MonBrightnessUp,exec,$osdclient --brightness raise"
        ",XF86MonBrightnessDown,exec,$osdclient --brightness lower"
        "ALT,XF86AudioRaiseVolume,exec,$osdclient --output-volume +1"
        "ALT,XF86AudioLowerVolume,exec,$osdclient --output-volume -1"
        "ALT,XF86MonBrightnessUp,exec,$osdclient --brightness +1"
        "ALT,XF86MonBrightnessDown,exec,$osdclient --brightness -1"
      ];

      bindmd = [ "SUPER,mouse:272,movewindow" "SUPER,mouse:273,resizewindow" ];

      # Variables for commands
      "$osdclient" = ''
        swayosd-client --monitor "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')"'';
    };
  };
}

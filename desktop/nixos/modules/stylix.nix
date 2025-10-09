{ pkgs, ... }: {
  stylix.enable = true;
  stylix.polarity = "dark";
  stylix.image =
    ../../1668510030_kartinkin-net-p-prizrak-tsusimi-art-oboi-13.jpg;
  stylix.fonts = with pkgs; {
    monospace = {
      package = nerd-fonts.jetbrains-mono;
      name = "JetBrains Mono";
    };
    serif = {
      package = dejavu_fonts;
      name = "DejaVu Serif";
    };
    sansSerif = {
      package = dejavu_fonts;
      name = "DejaVu Sans";
    };
    emoji = {
      package = noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };
  stylix.opacity = {
    applications = 0.9;
    terminal = 0.9;
    desktop = 0.9;
    popups = 0.9;
  };
  stylix.cursor = with pkgs; {
    package = comixcursors;
    name = "Opaque_Slim_White";
    size = 24;
  };
}

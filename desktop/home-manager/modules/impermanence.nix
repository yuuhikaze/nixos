{
  home.persistence."/persist/home/user" = {
    directories = [
      "Downloads"
      "Pictures"
      "Documents"
      "Videos"
      ".ssh"
      ".local/share/keyrings"
    ];
    allowOther = true;
  };
}

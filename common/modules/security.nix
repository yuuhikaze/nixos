{
  security = {
    # Enable AppArmor for system and container security
    apparmor.enable = true;
    # tpm2.enable = true;
    # Expose /run/current-system/sw/lib/libtpm2_pkcs11.so
    # tpm2.pkcs11.enable = true;
    # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
    # tpm2.tctiEnvironment.enable = true;
    sudo.extraConfig = ''
      # Suppress nagging when escalating to superuser
      Defaults lecture = never
    '';
  };
}

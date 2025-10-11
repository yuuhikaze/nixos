{ host ? null, ... }:
if host == null then
  throw "You must specify a host"
else {
  config.facter.reportPath =
    if builtins.pathExists "../../${host}/facter.json" then
      "facter.json"
    else
      throw
      "You need to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`";
}

{ host ? null, ... }:
let facterPath = toString ./. + "/../../${host}/facter.json";
in if host == null then
  throw "You must specify a host"
else {
  config.facter.reportPath = if builtins.pathExists facterPath then
    facterPath
  else
    throw
    "You need to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`";
}

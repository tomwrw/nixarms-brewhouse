# Sets up flake-parts. The modules module adds `flake.modules`, where every
# other file puts its piece of config. You only import it once, here.
{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  systems = [ "x86_64-linux" ];
}

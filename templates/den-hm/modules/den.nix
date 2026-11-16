# Switches den on, along with one of its batteries (ready-made aspects):
# hostname, which names each computer after its entry in den.hosts.
{ inputs, den, ... }:
{
  imports = [ inputs.den.flakeModule ];

  systems = [ "x86_64-linux" ];

  den.default.includes = [ den.batteries.hostname ];
}

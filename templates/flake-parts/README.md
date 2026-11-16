# The flake-parts starter

Step 3 of 5 in [the Brewhouse](https://nixarms.com/brewhouse/flake-parts/): a flake split into separate modules, so a growing config stays tidy.

It builds a KDE Plasma desktop with Firefox, LibreOffice, VLC and Steam, for one user. This one doesn't use Home Manager. [`flake-parts-hm`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/flake-parts-hm) is the same starter with it.

It builds exactly the same computer as the [`flakes`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/flakes) starter; the Brewhouse checks that on every change. What's different is where things live.

## What's here

| File | What it does |
| --- | --- |
| `flake.nix` | Pins NixOS 26.05 and flake-parts, then lists the modules below. |
| `flake.lock` | The exact versions in use, written by Nix. You don't edit it by hand. |
| `hosts/snug.nix` | The computer called `snug`. A second computer would be a second file here. |
| `vm.nix` | Gives you `nix run .#vm`. One job, one file: that's the point of flake-parts. |
| `configuration.nix` | The computer itself: desktop, apps and your account. Your details are in the block at the top. |
| `hardware-configuration.nix` | A placeholder, until you swap in your own. |

## Try it

```sh
nix run .#vm
```

That boots this config in a throwaway virtual machine, logged in as `alice` (the password is `changeme`). Close the window when you're done. Nothing is saved, and nothing on your computer changes.

## Make it yours

1. Copy in your computer's own hardware file, over the placeholder:

   ```sh
   cp /etc/nixos/hardware-configuration.nix .
   ```

2. Search for `CHANGE ME` and fill in your details. Most are at the top of `configuration.nix`. If you change the hostname, rename `snug` in `hosts/snug.nix` and `vm.nix` too.
   - Use the account name you picked in the installer. A new name means a new, empty account.
   - Copy `stateVersion` from the `configuration.nix` the installer gave you.
3. If this folder is a git repo, run `git add .` first. Flakes only see files git knows about.
4. Try your own copy in the VM: `nix run .#vm`
5. Switch to it:

   ```sh
   sudo nixos-rebuild switch --flake .#snug
   ```

From then on, edit, then run step 5 again. If a change goes wrong, pick the previous generation from the boot menu and you're back where you were.

## Keeping it up to date

`nix flake update` moves you to the latest NixOS 26.05 fixes; then switch again. A new NixOS release (26.11, say) means changing `nixos-26.05` in `flake.nix`.

## Next step

flake-parts tidies the flake, but `configuration.nix` is still one file per machine. [The dendritic pattern](https://nixarms.com/brewhouse/dendritic/) organises by feature instead. The [`dendritic`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/dendritic) starter builds this exact computer that way.

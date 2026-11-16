# The flake-parts starter, with Home Manager

Step 3 of 5 in [the Brewhouse](https://nixarms.com/brewhouse/flake-parts/): a flake split into separate modules, so a growing config stays tidy.

It builds a KDE Plasma desktop with Firefox, LibreOffice, VLC and Steam, for one user. Home Manager looks after that user's own apps and settings. [`flake-parts`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/flake-parts) is the same starter without it.

It builds exactly the same computer as the [`flakes-hm`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/flakes-hm) starter; the Brewhouse checks that on every change. What's different is where things live.

## What's here

| File | What it does |
| --- | --- |
| `flake.nix` | Pins NixOS 26.05, the matching Home Manager and flake-parts, then lists the modules below. |
| `flake.lock` | The exact versions in use, written by Nix. You don't edit it by hand. |
| `vm.nix` | Gives you `nix run .#vm`. One job, one file: that's the point of flake-parts. |
| `home.nix` | You, through Home Manager: your apps, git and your shell. It sits outside `hosts/`, so every computer can share it. |
| `hosts/snug/default.nix` | Hands the computer called `snug` to the flake, with Home Manager added. It's a flake-parts module, so it describes the flake, not the computer. |
| `hosts/snug/configuration.nix` | The computer itself: desktop, system apps and your account. Your details are in the block at the top. |
| `hosts/snug/hardware-configuration.nix` | A placeholder, until you swap in your own. |

Everything that belongs to `snug` is in its folder. To add a computer, copy that folder within `hosts/`, then in the copy change the name in `default.nix` and `configuration.nix`, swap in that computer's own hardware file, and add the new folder to `flake.nix`'s imports. The new computer picks up `home.nix` as it is.

## Try it

```sh
nix run .#vm
```

That boots this config in a throwaway virtual machine, logged in as `alice` (the password is `changeme`). Close the window when you're done. Nothing is saved, and nothing on your computer changes.

## Make it yours

1. Copy in your computer's own hardware file, over the placeholder:

   ```sh
   cp /etc/nixos/hardware-configuration.nix hosts/snug/hardware-configuration.nix
   ```

2. Search for `CHANGE ME` and fill in your details. Most are at the top of `hosts/snug/configuration.nix`, and your git name and email are in `home.nix`. If you change the hostname, rename `snug` in `hosts/snug/default.nix` and `vm.nix` too, rename the `snug` folder, and update its path in `flake.nix`.
   - Use the account name you picked in the installer. A new name means a new, empty account.
   - Copy `stateVersion` from the `configuration.nix` the installer gave you.
3. If this folder is a git repo, run `git add .` first. Flakes only see files git knows about.
4. Try your own copy in the VM: `nix run .#vm`
5. Switch to it:

   ```sh
   sudo nixos-rebuild switch --flake .#snug
   ```

From then on, edit, then run step 5 again. If a change goes wrong, pick the previous generation from the boot menu and you're back where you were.

Home Manager won't overwrite dotfiles you already have, such as `~/.bashrc`. It renames each one to `*.backup` and puts its own in place.

## Keeping it up to date

`nix flake update` moves you to the latest NixOS 26.05 and Home Manager fixes; then switch again. A new NixOS release (26.11, say) means changing `nixos-26.05` and `release-26.05` in `flake.nix` together. The two must always match.

## Next step

flake-parts tidies the flake, but each computer still has its own `configuration.nix`, so anything two computers share gets copied into both. [The dendritic pattern](https://nixarms.com/brewhouse/dendritic/) organises by feature instead. The [`dendritic-hm`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/dendritic-hm) starter builds this exact computer that way.

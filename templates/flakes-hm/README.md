# The flakes starter, with Home Manager

Step 2 of 5 in [the Brewhouse](https://nixarms.com/brewhouse/flakes/): your config plus a lock file that pins every input. Same pint, every time.

It builds a KDE Plasma desktop with Firefox, LibreOffice, VLC and Steam, for one user. Home Manager looks after that user's own apps and settings. [`flakes`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/flakes) is the same starter without it.

## What's here

| File | What it does |
| --- | --- |
| `flake.nix` | Pins NixOS 26.05 and the matching Home Manager, and names the computer `snug`. Also gives you `nix run .#vm`. |
| `flake.lock` | The exact versions in use, written by Nix. You don't edit it by hand. |
| `configuration.nix` | The computer itself: desktop, system apps and your account. Your details are in the block at the top. |
| `home.nix` | Your corner of it: your apps, git and your shell, through Home Manager. |
| `hardware-configuration.nix` | A placeholder, until you swap in your own. |

## Try it

```sh
nix run .#vm
```

That boots this config in a throwaway virtual machine, logged in as `alice` (the password is `changeme`). Close the window when you're done. Nothing is saved, and nothing on your computer changes.

On a fresh NixOS, flakes aren't switched on until you've switched to this starter, so until then use `nix --extra-experimental-features "nix-command flakes" run .#vm`.

On Windows, or to rehearse the whole install first, [the guide on nixarms.com](https://nixarms.com/brewhouse/starters/flakes/) walks you through trying it in VirtualBox.

## Make it yours

1. Copy in your computer's own hardware file, over the placeholder:

   ```sh
   cp /etc/nixos/hardware-configuration.nix .
   ```

2. Search for `CHANGE ME` and fill in your details. They're at the top of `configuration.nix`, your git name and email are in `home.nix`, and the name in `flake.nix` has to match your hostname.
   - Use the account name you picked in the installer. A new name means a new, empty account.
   - Copy `stateVersion` from the `configuration.nix` the installer gave you.
3. Bring across your PC's own lines. The installer put a few settings in `/etc/nixos/configuration.nix` that belong to your PC alone, and this starter replaces that file. This finds them:

   ```sh
   grep -nE "boot\.loader|boot\.initrd" /etc/nixos/configuration.nix
   ```

   - `boot.loader.grub` lines mean your PC starts up with GRUB, as older PCs do. Use them in place of the starter's two `boot.loader` lines in `configuration.nix`.
   - `boot.initrd.luks` or `boot.initrd.secrets` lines unlock an encrypted disk. Copy them into `configuration.nix` as they are. Without them, parts of your disk may not unlock.

   If you only see `systemd-boot` and `efi`, the starter has those already.
4. If this folder is a git repo, run `git add .` first. Flakes only see files git knows about.
5. Try your own copy in the VM: `nix run .#vm` (with the long flag from [Try it](#try-it), on a fresh NixOS)
6. Switch to it:

   ```sh
   sudo nixos-rebuild switch --flake .#snug
   ```

From then on, edit, then run step 6 again. If a change goes wrong, pick the previous generation from the boot menu and you're back where you were. Always keep the `--flake .#snug`: without it, `nixos-rebuild` builds the old config in `/etc/nixos` instead.

Home Manager won't overwrite dotfiles you already have, such as `~/.bashrc`. It renames each one to `*.backup` and puts its own in place. If a `*.backup` file is already there, the switch stops with "would be clobbered": move the old backup somewhere else and switch again.

## Keeping it up to date

`nix flake update` moves you to the latest NixOS 26.05 and Home Manager fixes; then switch again. A new NixOS release (26.11, say) means changing `nixos-26.05` and `release-26.05` in `flake.nix` together. The two must always match.

## Next step

When you've got a few machines, or `flake.nix` starts doing too many jobs, [flake-parts](https://nixarms.com/brewhouse/flake-parts/) splits it into tidy modules. The [`flake-parts-hm`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/flake-parts-hm) starter builds this exact computer that way.

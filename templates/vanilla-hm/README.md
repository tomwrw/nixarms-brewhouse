# The vanilla starter, with Home Manager

Step 1 of 5 in [the Brewhouse](https://nixarms.com/brewhouse/vanilla/), the house pour: config files in `/etc/nixos`, the shape the installer gives you. No flakes.

It builds a KDE Plasma desktop with Firefox, LibreOffice, VLC and Steam, for one user. Home Manager looks after that user's own apps and settings, and comes from a channel. [`vanilla`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/vanilla) is the same starter without it.

## What's here

| File | What it does |
| --- | --- |
| `configuration.nix` | The computer itself: desktop, system apps and your account. Your details are in the block at the top. |
| `home.nix` | Your corner of it: your apps, git and your shell, through Home Manager. |
| `hardware-configuration.nix` | A placeholder, so the test VM works. On your computer, you keep your own. |

There's no lock file. Your channels decide which versions you get; `sudo nix-channel --list` shows them.

## Try it

From any Linux computer with Nix:

```sh
nix run github:tomwrw/nixarms-brewhouse#vanilla-hm
```

That boots this config in a throwaway virtual machine, logged in as `alice` (the password is `changeme`). Close the window when you're done. Nothing is saved, and nothing on your computer changes.

On Windows, or to rehearse the whole install first, [the guide on nixarms.com](https://nixarms.com/brewhouse/starters/vanilla/) walks you through trying it in VirtualBox.

## Make it yours

This starter replaces your `configuration.nix`, so keep a copy of the old one first.

1. Back up what you've got:

   ```sh
   sudo cp -r /etc/nixos /etc/nixos.bak
   ```

2. Add the Home Manager channel. Its release has to match your NixOS channel, so check that one says `nixos-26.05` with `sudo nix-channel --list`.

   ```sh
   sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz home-manager
   sudo nix-channel --update
   ```

3. Get `configuration.nix` and `home.nix` from this folder, either from GitHub or with:

   ```sh
   nix --extra-experimental-features "nix-command flakes" flake init -t github:tomwrw/nixarms-brewhouse#vanilla-hm
   ```

4. Search for `CHANGE ME` and fill in your details. They're in the block at the top of `configuration.nix`, and your git name and email are in `home.nix`.
   - Use the account name you picked in the installer. A new name means a new, empty account.
   - Copy `stateVersion` from your old `configuration.nix`.
5. Bring across your PC's own lines. The installer put a few settings in `/etc/nixos/configuration.nix` that belong to your PC alone, and this starter replaces that file. This finds them:

   ```sh
   grep -nE "boot\.loader|boot\.initrd" /etc/nixos/configuration.nix
   ```

   - `boot.loader.grub` lines mean your PC starts up with GRUB, as older PCs do. Use them in place of the starter's two `boot.loader` lines.
   - `boot.initrd.luks` or `boot.initrd.secrets` lines unlock an encrypted disk. Copy them in as they are. Without them, parts of your disk may not unlock.

   If you only see `systemd-boot` and `efi`, the starter has those already.
6. Put them in place, keeping your own `hardware-configuration.nix`:

   ```sh
   sudo cp configuration.nix home.nix /etc/nixos/
   ```

7. Try it in a VM before you switch. From your home folder:

   ```sh
   nixos-rebuild build-vm && ./result/bin/run-*-vm
   ```

8. Switch to it:

   ```sh
   sudo nixos-rebuild switch
   ```

From then on, edit the files in `/etc/nixos`, then run step 8 again. If a change goes wrong, pick the previous generation from the boot menu and you're back where you were.

Home Manager won't overwrite dotfiles you already have, such as `~/.bashrc`. It renames each one to `*.backup` and puts its own in place. If a `*.backup` file is already there, the switch stops with "would be clobbered": move the old backup somewhere else and switch again.

## Keeping it up to date

`sudo nixos-rebuild switch --upgrade-all` fetches the latest fixes for both channels and switches to them. Plain `--upgrade` only updates the NixOS channel, so Home Manager would fall behind. When you move to a new NixOS release, move the Home Manager channel to the matching release too.

## Next step

When you want the same result on every machine, every time, [flakes](https://nixarms.com/brewhouse/flakes/) pin the exact versions in a lock file, and Home Manager becomes just another input. The [`flakes-hm`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/flakes-hm) starter builds this exact computer that way.

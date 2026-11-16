# The vanilla starter

Step 1 of 5 in [the Brewhouse](https://nixarms.com/brewhouse/vanilla/), the house pour: one file in `/etc/nixos`, exactly the shape the installer gives you. No flakes, no extra tools.

It builds a KDE Plasma desktop with Firefox, LibreOffice, VLC and Steam, for one user. This one doesn't use Home Manager. [`vanilla-hm`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/vanilla-hm) is the same starter with it.

## What's here

| File | What it does |
| --- | --- |
| `configuration.nix` | The computer itself: desktop, apps and your account. Your details are in the block at the top. |
| `hardware-configuration.nix` | A placeholder, so the test VM works. On your computer, you keep your own. |

There's no lock file. Your NixOS channel decides which version you get; `sudo nix-channel --list` shows it.

## Try it

From any Linux computer with Nix:

```sh
nix run github:tomwrw/nixarms-brewhouse#vanilla
```

That boots this config in a throwaway virtual machine, logged in as `alice` (the password is `changeme`). Close the window when you're done. Nothing is saved, and nothing on your computer changes.

On Windows, or to rehearse the whole install first, [the guide on nixarms.com](https://nixarms.com/brewhouse/starters/vanilla/) walks you through trying it in VirtualBox.

## Make it yours

This starter replaces your `configuration.nix`, so keep a copy of the old one first.

1. Back up what you've got:

   ```sh
   sudo cp -r /etc/nixos /etc/nixos.bak
   ```

2. Get `configuration.nix` from this folder, either from GitHub or with:

   ```sh
   nix --extra-experimental-features "nix-command flakes" flake init -t github:tomwrw/nixarms-brewhouse#vanilla
   ```

3. Search for `CHANGE ME` and fill in your details. They're all in the block at the top.
   - Use the account name you picked in the installer. A new name means a new, empty account.
   - Copy `stateVersion` from your old `configuration.nix`.
4. Bring across your PC's own lines. The installer put a few settings in `/etc/nixos/configuration.nix` that belong to your PC alone, and this starter replaces that file. This finds them:

   ```sh
   grep -nE "boot\.loader|boot\.initrd" /etc/nixos/configuration.nix
   ```

   - `boot.loader.grub` lines mean your PC starts up with GRUB, as older PCs do. Use them in place of the starter's two `boot.loader` lines.
   - `boot.initrd.luks` or `boot.initrd.secrets` lines unlock an encrypted disk. Copy them in as they are. Without them, parts of your disk may not unlock.

   If you only see `systemd-boot` and `efi`, the starter has those already.
5. Put it in place, keeping your own `hardware-configuration.nix`:

   ```sh
   sudo cp configuration.nix /etc/nixos/configuration.nix
   ```

6. Try it in a VM before you switch. From your home folder:

   ```sh
   nixos-rebuild build-vm && ./result/bin/run-*-vm
   ```

7. Switch to it:

   ```sh
   sudo nixos-rebuild switch
   ```

From then on, edit `/etc/nixos/configuration.nix`, then run step 7 again. If a change goes wrong, pick the previous generation from the boot menu and you're back where you were.

## Keeping it up to date

`sudo nixos-rebuild switch --upgrade` fetches the latest fixes for your channel and switches to them.

## Next step

When you want the same result on every machine, every time, [flakes](https://nixarms.com/brewhouse/flakes/) pin the exact versions in a lock file. The [`flakes`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/flakes) starter builds this exact computer that way.

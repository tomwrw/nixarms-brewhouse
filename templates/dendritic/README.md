# The dendritic starter

Step 4 of 5 in [the Brewhouse](https://nixarms.com/brewhouse/dendritic/): organise by feature, not by machine. Every file is a module, and they're all loaded automatically.

It builds a KDE Plasma desktop with Firefox, LibreOffice, VLC and Steam, for one user. This one doesn't use Home Manager. [`dendritic-hm`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/dendritic-hm) is the same starter with it.

It builds exactly the same computer as the [`flakes`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/flakes) starter; the Brewhouse checks that on every change. What's different is where things live: there's no `configuration.nix` any more. Each feature has its own file, and the computer is a list of features.

## What's here

| File | What it does |
| --- | --- |
| `flake.nix` | Pins NixOS 26.05, flake-parts and import-tree, then loads everything in `modules/`. |
| `flake.lock` | The exact versions in use, written by Nix. You don't edit it by hand. |
| `modules/flake-parts.nix` | Sets up flake-parts, including the `flake.modules` option every other file uses. |
| `modules/base.nix` | What every machine gets: booting, networking, language and Nix. |
| `modules/desktop.nix` | KDE Plasma, sound and printing. |
| `modules/apps.nix` | Apps for everyone on the computer. |
| `modules/gaming.nix` | Steam. |
| `modules/users/alice.nix` | You: your account and your own apps. |
| `modules/hosts/snug.nix` | The computer called `snug`: its list of features, and the facts that are its alone. |
| `modules/vm.nix` | Settings for the test VM, and `nix run .#vm`. |
| `hardware-configuration.nix` | A placeholder, until you swap in your own. It sits outside `modules/` so it isn't loaded automatically. |

To add a feature, add a file to `modules/` and put its name in the host's list. You never have to register the file anywhere.

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

2. Search for `CHANGE ME` and fill in your details. They're spread out on purpose, each one in the feature it belongs to:
   - language and keyboard in `modules/base.nix`;
   - your account in `modules/users/alice.nix`. Use the account name you picked in the installer; a new name means a new, empty account;
   - the hostname and `stateVersion` in `modules/hosts/snug.nix`. Copy `stateVersion` from the `configuration.nix` the installer gave you;
   - your account name again in `modules/vm.nix`, for the VM's automatic login.
3. If this folder is a git repo, run `git add .` first. Flakes only see files git knows about, and import-tree only loads what the flake can see.
4. Try your own copy in the VM: `nix run .#vm`
5. Switch to it:

   ```sh
   sudo nixos-rebuild switch --flake .#snug
   ```

From then on, edit, then run step 5 again. If a change goes wrong, pick the previous generation from the boot menu and you're back where you were.

## Keeping it up to date

`nix flake update` moves you to the latest NixOS 26.05 fixes; then switch again. A new NixOS release (26.11, say) means changing `nixos-26.05` in `flake.nix`.

## Next step

[den](https://nixarms.com/brewhouse/den/) is a framework that organises a config into reusable aspects, with hosts and users declared once and shared between them. It covers NixOS, Macs and Home Manager in one config. The [`den`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/den) starter builds this exact computer that way.

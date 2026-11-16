# The den starter, with Home Manager

Step 5 of 5 in [the Brewhouse](https://nixarms.com/brewhouse/den/), the full brewery: [den](https://github.com/denful/den) is a framework that organises a config into reusable aspects. You declare hosts and users once, and den builds each one from the aspects it includes.

It builds a KDE Plasma desktop with Firefox, LibreOffice, VLC and Steam, for one user. Home Manager looks after that user's own apps and settings. [`den`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/den) is the same starter without it.

It builds exactly the same computer as the [`flakes-hm`](https://github.com/tomwrw/nixarms-brewhouse/tree/main/templates/flakes-hm) starter; the Brewhouse checks that on every change. What's different is where things live.

## What's here

| File | What it does |
| --- | --- |
| `flake.nix` | Pins NixOS 26.05, the matching Home Manager, flake-parts, import-tree and den, then loads everything in `modules/`. |
| `flake.lock` | The exact versions in use, written by Nix. You don't edit it by hand. |
| `modules/den.nix` | Switches den on, with its hostname battery (a ready-made aspect). |
| `modules/hosts/snug/default.nix` | The computer called `snug`: who uses it, and what it includes. Giving `alice` the `homeManager` class is what switches Home Manager on. |
| `modules/hosts/snug/_hardware-configuration.nix` | A placeholder, until you swap in your own. The `_` stops import-tree loading it by itself, so only `snug` uses it. |
| `modules/aspects/base.nix` | What every machine gets: booting, networking, language and Nix. |
| `modules/aspects/desktop.nix` | KDE Plasma, sound and printing. |
| `modules/aspects/apps.nix` | Apps for everyone on the computer. |
| `modules/aspects/gaming.nix` | Steam. |
| `modules/aspects/home-manager.nix` | How Home Manager behaves. |
| `modules/aspects/vm.nix` | Settings for the test VM, and `nix run .#vm`. |
| `modules/users/alice.nix` | You: your account, and your apps, git and shell for Home Manager. |

To add a feature, add a file to `modules/aspects/` and put it in the host's `includes`. To add a computer, add a folder to `modules/hosts/` with its own `default.nix` and `_hardware-configuration.nix`; its `default.nix` says who uses it and what it includes, as `snug`'s does. Anyone listed on two computers gets the same account and Home Manager setup on both.

## Try it

```sh
nix run .#vm
```

That boots this config in a throwaway virtual machine, logged in as `alice` (the password is `changeme`). Close the window when you're done. Nothing is saved, and nothing on your computer changes.

## Make it yours

1. Copy in your computer's own hardware file, over the placeholder. Keep the `_` at the start of its name:

   ```sh
   cp /etc/nixos/hardware-configuration.nix modules/hosts/snug/_hardware-configuration.nix
   ```

2. Search for `CHANGE ME` and fill in your details:
   - your hostname and account name in `modules/hosts/snug/default.nix`. den uses those names everywhere, so rename `den.aspects.snug`, the `snug` folder and `modules/users/alice.nix` to match. Use the account name you picked in the installer; a new name means a new, empty account;
   - `stateVersion` in `modules/hosts/snug/default.nix`. Copy it from the `configuration.nix` the installer gave you;
   - language and keyboard in `modules/aspects/base.nix`;
   - your git name and email in `modules/users/alice.nix`;
   - your account name again in `modules/aspects/vm.nix`, for the VM's automatic login.
3. If this folder is a git repo, run `git add .` first. Flakes only see files git knows about, and import-tree only loads what the flake can see.
4. Try your own copy in the VM: `nix run .#vm`
5. Switch to it:

   ```sh
   sudo nixos-rebuild switch --flake .#snug
   ```

From then on, edit, then run step 5 again. If a change goes wrong, pick the previous generation from the boot menu and you're back where you were.

Home Manager won't overwrite dotfiles you already have, such as `~/.bashrc`. It renames each one to `*.backup` and puts its own in place.

## Keeping it up to date

`nix flake update` moves you to the latest NixOS 26.05 and Home Manager fixes; then switch again. A new NixOS release (26.11, say) means changing `nixos-26.05` and `release-26.05` in `flake.nix` together. The two must always match.

den is pinned to a release, `v0.20.0`, and `nix flake update` leaves it there. It's young and its releases sometimes change how things work, so read [its release notes](https://github.com/denful/den/releases) before you change the version in `flake.nix`.

## Going further

den's own [documentation](https://den.denful.dev) covers what this starter leaves out: more hosts, Macs, standalone Home Manager and policies.

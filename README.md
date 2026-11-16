# The Nix Arms Brewhouse

Starter configs for [the Brewhouse](https://nixarms.com/brewhouse/) at The Nix Arms: five ways to organise a NixOS config, each with and without Home Manager. Ten starters, one pint.

Every starter builds the same computer:

- a KDE Plasma desktop, with sound and printing
- Firefox, LibreOffice and VLC
- Steam
- one user, `alice`, on a computer called `snug`

Only the structure changes, and I check that on every change. The four flake starters without Home Manager build exactly the same system (the same Nix derivation), and so do the four with it. Vanilla gets its NixOS from a channel rather than a lock file, so it's checked on its own. Put any two side by side and you'll see what a method changes, and nothing else.

## Pick your method

The Brewhouse is a ladder. Start at the top, and only climb when the step you're on starts to pinch.

| Step | Method | Without Home Manager | With Home Manager |
| --- | --- | --- | --- |
| 1 | [Vanilla configuration.nix](https://nixarms.com/brewhouse/vanilla/) | [`vanilla`](templates/vanilla/) | [`vanilla-hm`](templates/vanilla-hm/) |
| 2 | [Flakes](https://nixarms.com/brewhouse/flakes/) | [`flakes`](templates/flakes/) | [`flakes-hm`](templates/flakes-hm/) |
| 3 | [flake-parts](https://nixarms.com/brewhouse/flake-parts/) | [`flake-parts`](templates/flake-parts/) | [`flake-parts-hm`](templates/flake-parts-hm/) |
| 4 | [The dendritic pattern](https://nixarms.com/brewhouse/dendritic/) | [`dendritic`](templates/dendritic/) | [`dendritic-hm`](templates/dendritic-hm/) |
| 5 | [den](https://nixarms.com/brewhouse/den/) | [`den`](templates/den/) | [`den-hm`](templates/den-hm/) |

Not sure? You don't need any of this on day one. Start with `vanilla`, which is the config the NixOS installer gives you, filled in. Home Manager is optional at every step; [the Brewhouse](https://nixarms.com/brewhouse/) explains what it's for.

## Try one

You can boot any starter in a throwaway virtual machine, without changing anything on your computer:

```sh
nix run github:tomwrw/nixarms-brewhouse#flakes-hm
```

Swap `flakes-hm` for the starter you want. It logs in as `alice` by itself (the password is `changeme`, if anything asks). Close the window when you're done; nothing is saved. `nix run github:tomwrw/nixarms-brewhouse` on its own lists all ten.

If Nix says flakes aren't switched on, add `--extra-experimental-features "nix-command flakes"` straight after `nix`.

Before you start, the honest limits:

- You need Linux on an ordinary (x86_64) PC, with Nix installed. It won't run on a Mac or on Windows.
- The first run downloads about 4 GB. The other starters reuse nearly all of it.
- It's far quicker with hardware virtualisation (KVM). Without it, the VM still works, slowly.
- Steam installs, but don't expect games to run well in a VM.

## Take one

For the flake starters (steps 2 to 5), in an empty folder:

```sh
nix flake init -t github:tomwrw/nixarms-brewhouse#flakes-hm
cp /etc/nixos/hardware-configuration.nix .
```

Then search for `CHANGE ME`, fill in your details, and switch:

```sh
sudo nixos-rebuild switch --flake .#snug
```

The vanilla starters have no flake, so they replace the files in `/etc/nixos` instead; their READMEs walk you through it. Every starter's README comes with you when you run `nix flake init`, so the full steps are always to hand.

A few things that catch people out:

- **Each starter's `hardware-configuration.nix` is a placeholder.** It lets the test VM boot, and it stops a real build with a reminder until you copy your own over it. The den starters keep it with the rest of the computer's files, as `modules/hosts/snug/_hardware-configuration.nix`.
- **Use the account name you picked in the installer.** Change `alice` to a name that doesn't exist yet and NixOS makes a new, empty account with the password `changeme`. If that happens, change the password with `passwd` straight away.
- **Copy `stateVersion` from your old `configuration.nix`.** It records the release you first installed, not the one you run, so don't change it after that.
- **If your config folder is a git repo, `git add` new files before you build.** Flakes only see files git knows about.

## What's in this repo

```text
templates/<name>/   the ten starters, each one complete on its own
flake.nix           lists the starters, so nix run and nix flake init work
ci/                 the checks that run on every change
```

The starters pin NixOS 26.05 and the matching Home Manager release, and each one ships with its own `flake.lock`, so you start from exactly the versions I tested. Every week a job updates the lock files, checks all ten still build, and opens a pull request. den is pinned to a release (`v0.20.0`) and only moves when I've checked the new one by hand.

To run the checks yourself:

```sh
ci/check-all.sh
```

## Licence

The code is MIT; see [LICENSE](LICENSE). Take what's useful.

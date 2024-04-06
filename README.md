# Linux Configuration Dotfiles

## Use Dotfiles

### 1. Use Auto Config Script

Run `configure.sh` to auto configure dotfiles, which will add links for all files to where they should be. 

### 2. Manually config

Use `ln`/`mv`/`cp` to add dotfiles to where they should be. 

## Maintaining The Repo

- The root folder below all refer to the repo root

---

- In `/home` folder, you put files which should work in your `~/` or `$HOME`;

- In `/config` folder, you place files which should work in your `~/.config`;

- In `/scripts` folder, you put smaller scripts you write for light-weight functionals;

- For different platforms (such as raspi, RDKx3, ArchLinux), you may push their configuration dotfiles in different branches and update `/configure.sh`/`/scripts/configure/sh` script.




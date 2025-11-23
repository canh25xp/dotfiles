# TODO

- [ ] Bootstrap scripts for **Portable mode** (for demonstration and testing purposes or when the machine is not mine)
  - [ ] This might required a lots of work, maybe move it to another project entirely ?
  - [ ] No machine modifications (or at least keep it as minimum as possible)
  - [ ] Required internet access as few as possible, preferably only at bootstrap time.
  - [ ] All applications should be download to a single directory and symlink their binaries to a single PATH variable environment.
  - [ ] Use cli applications only.
  - [ ] Should be easy to revert and clean up.
  - [ ] Single command, all options should be pass to script as cli argument, after that, don't ask for user's input.
- [x] Toggle Terminal Background Opacity
- [ ] Quick select terminal background via `fzf`
- [ ] Manage API keys and tokens via `age`
- [x] Dynamic ssh config profiles (change hostname based on current machine)
- [x] Add nvim-obsidian plugins
- [x] Maybe add some screenshots to flex my setup ?
- [ ] Quick open DevNote keymap
- [ ] `cht.sh` client installation
- [ ] Fully automate init process (Everything with single command `chezmoi init --apply`)
      Regardless of work or home, linux or windows.
      This task consider done when all of my machine can be fully automatically initialize, or at least no error occurs.
  - [ ] work Windows
  - [ ] home Windows
  - [ ] work Debian
  - [ ] home Debian
  - [ ] phone Termux
  - [ ] tablet Termux

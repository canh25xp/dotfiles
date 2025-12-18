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
- [x] Quick select terminal background via `fzf`
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
- [ ] **BUG FIX**:
  - [ ] Termux: chezmoi data is not recognize .chezmoi.username, maybe come up with other way to register private device in Termux
  - [ ] Windows: `eza` check installation before add `ls` alias
  - [ ] Windows: `bat` check installation before add `cat` alias
- [ ] Consistency: use `home` instead of `personal`
- [x] Ignore app configs if the app it self not found (using lookPath)
- [ ] `gpg` encrypted files (.ssh/id\*) are initialize way too slow on Windows, and way too often. [#4807](https://github.com/twpayne/chezmoi/discussions/4807#discussioncomment-15166685)
- [ ] Dealing with encrypted files when `age` recipients key has not initialized.
- [ ] Automate installing from external package managers `cargo`, `npm`, ...
- [ ] Add support to encrypted notes in [DevNote](https://github.com/canh25xp/DevNote)

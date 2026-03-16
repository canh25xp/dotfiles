# Keybindings

This is not a list if Keybindings for any particular applications, but rather a guideline for choosing a semantic and consistent keybindings across my applications.
Prioritize to use vim-like bindings if possible.

## Letters (A–Z)

`h,j,k,l` should always map to `left, down, up, right` direction if possible.

| Key | Meanings                                           |
| --- | -------------------------------------------------- |
| A   | Append, Add, Around, All, Archive, AI              |
| B   | Backward, Buffer, Build, Bottom                    |
| C   | Change, Copy, Create, Close, Code, Compile, Config |
| D   | Delete, Down, Debug, Diff, Duplicate               |
| E   | End, Edit, Execute, Eval, Expand                   |
| F   | Forward, Find, File, Format                        |
| G   | Go, Git, Group, Generate                           |
| H   | Home, Help, History, Hide, Hunk[^1]                |
| I   | Insert, Info, Import, Inspect, Inlay               |
| J   | Join, Jump, Justify                                |
| K   | Keyword, Kill, Keybindings, Keep/Bookmark          |
| L   | List, Line, Log, Lazy[^2]                          |
| M   | Mark, Move, Menu, Merge, Mason[^3]                 |
| N   | Next, New, Navigate                                |
| O   | Open, Options, Outline                             |
| P   | Paste, Previous, Project, Print, Preview           |
| Q   | Quit, Quick, Queue                                 |
| R   | Replace, Rename, Run, Reload, Reference            |
| S   | Substitute, Save, Search, Split, Sort, Sync        |
| T   | Till[^4], Tab, Toggle, Terminal, Test, Tree        |
| U   | Undo, Up, Update, Upload                           |
| V   | Visual, View, Version Control, Verify              |
| W   | Word, Window, Write, Workspace, Wrap               |
| X   | Cut, Close, eXchange                               |
| Y   | Yank[^5], Yes                                      |
| Z   | Fold[^7], Redraw, Undo, Zoom, Suspend[^8]          |

[^1]: a hunk is a block of changes in git (or any version control system)

[^2]: as in lazgit, lazyvim,...

[^3]: nvim's package manager [github](https://github.com/mason-org/mason.nvim)

[^4]: As in until, or upto some point

[^5]: Yank mean copy

[^6]: Think of it like the z fold phone

[^7]: Think of it like sleep (Zzz)

## Numbers (0–9)

Use 1-8 to refer to the index of an ordered list (tabs, buffers, windows, ...) but reserved 0 and 9 for first and last index.

## Punctuation & Special Characters

> [!WARNING]
> AI Generated, need review

| Key   | Meanings                                       |
| ----- | ---------------------------------------------- |
| `     | Toggle, jump                                   |
| ~     | Home, Alternate, Tilde-expand                  |
| !     | Force, Shell command, Negate                   |
| @     | Metadata, Macro, Annotation                    |
| #     | Comment, Tag, Heading                          |
| $     | End of line, Variable                          |
| %     | Whole file, Placeholder, Vertical split (tmux) |
| ^     | Beginning of line, Control concept             |
| &     | Background task, Combine                       |
| /     | Search, Slash commands                         |
| ?     | Backwards search, Help                         |
| \*    | Leader prefix, Namespace                       |
| \|    | Pipe, Vertical split                           |
| :     | Command mode, Exec command palette             |
| ;     | Repeat, Secondary command                      |
| ,     | Repeat, recent, hide                           |
| .     | Repeat (counterclockwise), recent, hide        |
| '     | Mark, Quote literal                            |
| "     | Registers, Secondary clipboard                 |
| <     | Shift left, Previous                           |
| >     | Shift right, Next                              |
| {}    | Block scope navigation                         |
| []    | List navigation, Surround                      |
| ()    | Expressions, Function start/end                |
| -     | Reduce, Previous, Decrease                     |
| +     | Add, Next, Increase                            |
| =     | Format, Align                                  |
| \_    | Hidden, Low-level, Alternative                 |
| Space | Leader, Menu, Universal prefix                 |

## Function Keys (F1–F12)

| Key     | Meaning                   |
| ------- | ------------------------- |
| **F1**  | Help                      |
| **F2**  | Rename                    |
| **F3**  | Find next / Search        |
| **F4**  | Close window / Quit       |
| **F5**  | Refresh / Reload          |
| **F6**  | Cycle panels/focus        |
| **F7**  | Build / Compilation       |
| **F8**  | Debug / Breakpoints       |
| **F9**  | Run                       |
| **F10** | Menu toggle               |
| **F11** | Fullscreen                |
| **F12** | Developer tools / Inspect |

## Modifier Key Semantics

| Modifier | Meaning                               |
| -------- | ------------------------------------- |
| Shift    | Extend / precise version of action    |
| Ctrl     | Core editing / low-level operations   |
| Alt      | Navigation, metadata, special actions |
| Win      | System/global actions                 |

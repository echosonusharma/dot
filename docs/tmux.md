# tmux cheat sheet

**Prefix:** `Ctrl + j` or `Ctrl + f`

### Panes
- `v` / `h` - Vertical / Horizontal split
- `Ctrl + Arrows` - Navigate (No prefix)
- `x` - Kill pane

### Windows
- `c` - New window
- `Shift + Arrows` - Switch windows
- `Ctrl + Shift + Arrows` - Reorder windows
- `,` - Rename window
- `&` - Kill window

### Sessions
- `tmux` - New session
- `tmux ls` - List sessions
- `tmux a` - Attach latest
- `tmux a -t <name>` - Attach specific
- `$` - Rename current session
- `s` - Switch session

### Misc
- `r` - Reload config
- `[` - Copy mode (`v` to select, `y` to copy)
- `p` - Paste
- `y` - Sync panes
- `d` - Detach session


# tmux (for default tmux setup)

tmux prefix is `ctrl+b`

- `tmux` creates a new session.
- `tmux a` attach to the most recent session.
- `tmux ls` to list active tmux sessions.
- `ctrl+b` is the prefix and then enter any tmux command.
- `ctrl+b` and then `d` will detach the session and exit to main terminal.

### tmux panes

- `ctrl+b` and then `%` to do a vertical split.
- `ctrl+b` and then `"` to do a horizontal split.
- to navigate use `ctrl+b` and the arrow keys.
- `exit` for exit the session or tmux prefix and then `x`.

### tmux windows

- `tmux new-session` for new window
- to create a new session when inside tmux use tmux prefix + `c`
- to navigate use tmux prefix + `p` for previous and `n` for next
- to delete a window use tmux prefix + `&`
- to rename a window use tmux prefix + `,`

### tmux session

- `tmux` for new session
- `tmux ls` for listing all tmux sessions
- `tmux a -t <session-number>` to attach to a specific session.
- `tmux rename-session <new-name>` for renaming the session.
- use tmux prefix + `$` to rename the current session.
- to switch between sessions use tmux prefix + `s` and select the session you want to use.
- to kill session use `tmux kill-session -t <session-number>`

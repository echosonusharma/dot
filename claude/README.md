# Claude Code config

## .claude/settings.json

Model `opus`, effort `high`, dark theme, plugins (caveman, frontend-design, gopls + rust-analyzer LSP).

`statusLine` points at an absolute nvm path. Node upgrades change that path — fix it after a node
version bump, or on a fresh machine, with:

```sh
npm i -g ccstatusline
which ccstatusline
```

`settings.local.json` is deliberately not tracked: per-project permission allowlists.

## .config/ccstatusline/settings.json

[ccstatusline](https://github.com/sirmalloc/ccstatusline) widgets: model, usable context %,
session cost, session clock, session usage, limit reset timer. No cwd, no git.

`rawValue: true` drops a widget's label prefix.

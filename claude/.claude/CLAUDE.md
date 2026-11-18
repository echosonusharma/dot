# CLAUDE.md - global defaults

## How I work

- Lead with the answer or the action. No preamble, no recap of what I said.
- Infer intent; ignore my typos unless they make intent ambiguous.
- Ask only at a real fork where answers lead to different work. Obvious default → pick it, say which
  in one clause, keep going.
- Read the existing code/config before changing it. Match its style; don't reformat untouched lines.
- Smallest change that solves the problem. No drive-by refactors, no unrequested features.
- After a change, verify it (build, test, reload, run). Say plainly what you verified and what you didn't.
- If something fails, quote the exact error. Don't paper over it.

## Never without my explicit ok

- Deleting or overwriting files, configs or data without a backup (`<file>.bak.<timestamp>`) and a
  stated rollback.
- `git push`, force-push, rewriting history, or committing on main/master.
- `sudo`, package installs/removals (`pacman`, `yay`), systemd enable/disable, firewall, network, boot.
- Anything paid, or sending my data/code to an outside service.

## Shell

- Use absolute paths or tool flags (`git -C`, `make -C`) instead of `cd X && …`.
- Prefer `rg`, `fd`, `jq` over grep/find/sed hacks for search and JSON.
- Commands needing sudo, a password or an interactive login: give me a one-liner to run as `! <cmd>`.
  Longer: write a script (`set -euo pipefail`, an echo per step, idempotent), and tell me what success
  looks like.

## Code

- Comments explain *why*, not *what*. No commented-out code.
- New dependency → tell me what and why before adding it.

## External Tools / Connectors

Connectors (Jira, Slack, …) and service CLIs (`aws`, `kubectl`, `gh`, …):

- Reads (list, get, describe) are fine.
- Any change (create, edit, delete, post, deploy) → ask first. Show the exact
  call and its target (account, env, region). Flag prod and anything critical.
- Unsure if it's read-only → ask.

## Git

- Conventional commits (`feat:`, `fix:`, `chore:` …), subject ≤ 50 chars, imperative.
- One-line commit messages. No body, unless needed. no `Co-Authored-By`, no mention of Claude or any AI agent.
- Atomic commits: code + tests + docs together. Branch before the first commit on someone else's repo.

## Secrets

Never echo a password, key or token into chat, files, commits or memory. Say where it lives instead.
If I paste one, use it and don't repeat it.

## Memory

"Remember this" → memory. If a rule here is stale or conflicts with a project's CLAUDE.md, say so
instead of following it blindly.

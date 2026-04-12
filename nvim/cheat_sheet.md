# Neovim Cheat Sheet

Your **Leader Key** is: `,` (comma)

## File & Navigation
| Key | Action |
|-----|--------|
| `-` | Open **Yazi** (File explorer) |
| `,u` | **Undo Tree** (Visual history) |
| `,ff` | **Find Files** (Telescope) |
| `,fg` | **Live Grep** (Search text across whole project) |
| `,fb` | Search Open **Buffers** |
| `,fh` | Search Help Tags |
| `,r` | **Reload** Neovim Config |
| `,t` | **Floating Terminal** (Open/Close) |

## Coding & LSP (Language Server)
| Key | Action |
|-----|--------|
| `gd` | **Go to Definition** (Jump to source) |
| `gr` | **Find References** (See everywhere it is used) |
| `K` | **Hover Documentation** (Show type and info) |
| `,cr` | **Rename** Symbol (Project-wide) |
| `,ca` | **Code Actions** (Quick fixes / Imports) |
| `(Save)` | **Auto-Format** (Triggered on save) |
| `(Auto)` | **Auto-Pairs** (Brackets and quotes close automatically) |

## Essential Vim Motions
### Movement
*   `h`, `j`, `k`, `l` → Left, Down, Up, Right
*   `w` → Jump to start of next word
*   `b` → Jump back to start of previous word
*   `e` → Jump to end of word
*   `0` → Jump to start of line
*   `$` → Jump to end of line
*   `gg` → Go to top of file
*   `G` → Go to bottom of file

### Editing
*   `i` → Insert mode
*   `,,` → Escape Insert mode (Fast escape)
*   `u` → Undo
*   `<C-r>` → Redo
*   `x` → Delete single character
*   `dw` → Delete word
*   `dd` → Delete line
*   `yy` → Yank (Copy) line
*   `p` → Paste (System clipboard)

## Search & Replace
*   `/pattern` → Search forward for pattern
*   `n` → Go to next search result
*   `N` → Go to previous search result
*   `:s/old/new/g` → Substitute old with new on current line

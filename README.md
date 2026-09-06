### Hi, I'm clang.engineer 👋

A backend-focused software developer. I majored in statistics and started out with C.  
These days I build data collection and analysis/visualization tools for general hospitals.

I work across the frontend too, and I enjoy building things as one flow — from design all the way to the interface.  
Neovim is my main editor. I care about fundamentals and how things work under the hood, and I keep refining my dev environment.

---

### Tech Stack

**Backend** — Java · Kotlin · Spring Boot · Spring Batch · JPA · Python  
**Frontend** — TypeScript · JavaScript · React  
**Data** — Oracle · MSSQL · Tibero · PostgreSQL · MySQL · Vertica · Elasticsearch  
**Systems** — C · C++  
**Infra** — Docker · Nginx · Linux  
**Editor** — Neovim (LazyVim)  
**Tools** — Git · tmux · fzf · ripgrep · Claude Code

---

### Open Source

#### [harlequin-h2](https://github.com/clang-engineer/harlequin-h2)

A community adapter that connects [Harlequin](https://harlequin.sh/) to H2 databases over JDBC, supporting embedded file, memory, and TCP modes.

Published on PyPI as `harlequin-h2`, and accepted into Harlequin's official community-adapter documentation via [tconbeer/harlequin-web#162](https://github.com/tconbeer/harlequin-web/pull/162).

#### [harlequin-odbc-vertica](https://github.com/clang-engineer/harlequin-odbc-vertica)

A Vertica-specific Harlequin ODBC adapter that handles Vertica catalog and column-metadata behavior on top of the standard ODBC integration.

Published on PyPI as `harlequin-odbc-vertica`; official Harlequin community-adapter documentation is being proposed via [tconbeer/harlequin-web#163](https://github.com/tconbeer/harlequin-web/pull/163).

#### [jvm-env.nvim](https://github.com/clang-engineer/jvm-env.nvim)

Auto-detects installed JDKs by major version and injects their paths into Neovim env vars — separate JDKs for jdtls (the language server) and Gradle (the build tool).

Resolves the right JDK per OS across jEnv, SDKMAN, Homebrew, apt, and scoop, without touching your shell's `JAVA_HOME`. Listed in [awesome-neovim](https://github.com/rockerBOO/awesome-neovim) via PR [#2365](https://github.com/rockerBOO/awesome-neovim/pull/2365).

#### [dadbod-vertica.nvim](https://github.com/clang-engineer/dadbod-vertica.nvim)

A [Vertica](https://www.vertica.com/) adapter for [vim-dadbod](https://github.com/tpope/vim-dadbod), wired through the official `vsql` client.

Brings the same URL-driven dadbod / dadbod-ui workflow you already use for PostgreSQL and MySQL to Vertica — schema browsing, query buffers, result splits, and completion. Listed in [awesome-neovim](https://github.com/rockerBOO/awesome-neovim) via PR [#2355](https://github.com/rockerBOO/awesome-neovim/pull/2355).

#### [dotfiles](https://github.com/clang-engineer/dotfiles)

My macOS development environment, all in one place.

- **Zsh** — oh-my-zsh, syntax-highlighting, autosuggestions, starship prompt
- **Neovim** — LazyVim-based Lua config + classic Vimscript config
- **tmux** — vim-tmux-navigator, resurrect, continuum
- **Git** — multi-account SSH, lazygit, gh CLI
- **Runtime management** — jenv (Java), nvm (Node), pyenv (Python), rbenv (Ruby)
- **macOS** — Hammerspoon window management, Brewfile package management

A single `./bootstrap.sh` sets up the whole environment.

#### [devkit](https://github.com/clang-engineer/devkit)

Curated dev cheatsheets, templates, and concept notes I keep handy.

- **cheatsheets/** — quick references for git, docker, tmux, fzf, jq, ripgrep, curl, ssh, nginx, kubectl, and more
- **templates/** — boilerplate like Docker Compose + Spring + Postgres, and a Makefile template
- **notes/** — concept notes: CAP theorem, RSA/AES, SQL injection, SSH vs SSL, Neovim internals, DB ops tips

---

### Blog

[clang-engineer.github.io](https://clang-engineer.github.io) — thoughts that don't compile

Neovim setup, Spring Boot, design patterns, shell scripting, Docker, AI tooling, and more —  
over 150 posts documenting what I've learned along the way.

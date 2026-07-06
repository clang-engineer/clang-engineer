### Hi, I'm clang.engineer 👋

A backend-focused software developer. I majored in statistics and started out with C.  
These days I build data collection and analysis/visualization tools at a general hospital.

I work across the frontend too, and I enjoy building things as one flow — from design all the way to the interface.  
Neovim is my main editor. I care about fundamentals and how things work under the hood, and I keep refining my dev environment.

---

### Tech Stack

**Backend** — Java · Kotlin · Spring Boot · Spring Batch · JPA · Python  
**Frontend** — TypeScript · JavaScript · React  
**Systems** — C · C++  
**Infra** — Docker · Nginx · Linux  
**Editor** — Neovim (LazyVim)  
**Tools** — Git · tmux · fzf · ripgrep · Claude Code

---

### Repositories

#### [dotfiles](https://github.com/clang-engineer/dotfiles)

My macOS development environment, all in one place.

- **Zsh** — oh-my-zsh, syntax-highlighting, autosuggestions, starship prompt
- **Neovim** — LazyVim-based Lua config + classic Vimscript config
- **tmux** — vim-tmux-navigator, resurrect, continuum
- **Git** — multi-account SSH, lazygit, gh CLI
- **Runtime management** — jenv (Java), nvm (Node), pyenv (Python), rbenv (Ruby)
- **macOS** — Hammerspoon window management, Brewfile package management

A single `./bootstrap.sh` sets up the whole environment.

#### [dadbod-vertica.nvim](https://github.com/clang-engineer/dadbod-vertica.nvim)

A [Vertica](https://www.vertica.com/) adapter for [vim-dadbod](https://github.com/tpope/vim-dadbod), wired through the official `vsql` client.

Brings the same URL-driven dadbod / dadbod-ui workflow you already use for PostgreSQL and MySQL to Vertica — schema browsing, query buffers, result splits, and completion.

#### [jvm-env.nvim](https://github.com/clang-engineer/jvm-env.nvim)

Auto-detects installed JDKs by major version and injects their paths into Neovim env vars — separate JDKs for jdtls (the language server) and Gradle (the build tool).

Resolves the right JDK per OS across jEnv, SDKMAN, Homebrew, apt, and scoop, without touching your shell's `JAVA_HOME`.

#### [toolbox](https://github.com/clang-engineer/toolbox)

A collection of scripts, cheatsheets, and notes I use while developing.

- **tools/** — practical scripts: git branch cleanup, bulk repo pull, disk cleanup, network switching, and more
- **cheatsheets/** — quick references for git, docker, vim, tmux, fzf, jq, curl, rg, and others
- **til/** — troubleshooting logs and today-I-learned notes
- **templates/** — boilerplate like Docker Compose + Spring + Postgres
- **analysis/** — per-project codebase analysis notes

---

### Blog

[clang-engineer.github.io](https://clang-engineer.github.io) — thoughts that don't compile

Neovim setup, Spring Boot, design patterns, shell scripting, Docker, AI tooling, and more —  
over 150 posts documenting what I've learned along the way.

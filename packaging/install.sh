#!/usr/bin/env bash
#
# Remote Pi (this fork) — laptop / headless-server installer
# ==========================================================
#
#   ./packaging/install.sh
#   ./packaging/install.sh --relay https://your-relay.example
#   curl -fsSL https://raw.githubusercontent.com/202121000995/remote_pi/main/packaging/install.sh | bash
#   curl -fsSL …/packaging/install.sh | bash -s -- --relay https://your-relay.example
#
# What it does (all user-space, NO sudo, idempotent):
#   1. Node      — system Node if >= 20.6.0; otherwise nvm under ~/.nvm.
#   2. Pi        — @earendil-works/pi-coding-agent into ~/.local (no root).
#   3. Extension — builds THIS repo's pi-extension (clone or --from tarball)
#                  and `pi install <local-path>`. Never defaults to
#                  `pi install npm:remote-pi` (upstream; still auto-runs
#                  gated tools).
#   4. CLI link  — symlinks `remote-pi` + `pi-supervisord` into ~/.local/bin.
#   5. Relay     — persists REMOTE_PI_RELAY / --relay to
#                  ~/.pi/remote/config.json (same writer as `remote-pi set-relay`).
#   6. Supervisor— `remote-pi install` (systemd --user on Linux; launchd on
#                  macOS — same command). Skipped with --skip-supervisor.
#   7. Pairing   — does NOT consume a pairing token (60s TTL; must stay live).
#                  Prints the exact `pi -e …` + `/remote-pi pair` commands
#                  that emit a copy-paste `remotepi://pair?…` URI for SSH.
#
# Re-running does not touch ~/.pi/remote/peers.json or identity.json.
#
set -euo pipefail

# ── Constants ────────────────────────────────────────────────────────────────

MIN_NODE="20.6.0"
NODE_LTS="22"
PI_PKG="@earendil-works/pi-coding-agent"
PLUGIN_NAME="remote-pi"
USER_PREFIX="$HOME/.local"
LOCAL_BIN="$USER_PREFIX/bin"
DEFAULT_FORK_REPO="https://github.com/202121000995/remote_pi.git"
DEFAULT_FORK_REF="main"
DEFAULT_SRC="$HOME/.local/src/remote_pi"

# ── Pretty output ────────────────────────────────────────────────────────────

if [ -t 1 ]; then
  BOLD=$'\033[1m'; DIM=$'\033[2m'; RED=$'\033[31m'; GRN=$'\033[32m'
  YLW=$'\033[33m'; BLU=$'\033[34m'; RST=$'\033[0m'
else
  BOLD=""; DIM=""; RED=""; GRN=""; YLW=""; BLU=""; RST=""
fi

step()  { printf '%s\n' "${BLU}${BOLD}==>${RST} ${BOLD}$*${RST}"; }
info()  { printf '%s\n' "    $*"; }
ok()    { printf '%s\n' "    ${GRN}✓${RST} $*"; }
warn()  { printf '%s\n' "    ${YLW}!${RST} $*"; }
die()   { printf '%s\n' "${RED}${BOLD}error:${RST} $*" >&2; exit 1; }

SUMMARY=()
record() { SUMMARY+=("$1"); }

# ── CLI ──────────────────────────────────────────────────────────────────────

usage() {
  cat <<EOF
${BOLD}Remote Pi (fork) installer${RST} — Pi + this repo's extension + supervisor

${BOLD}Usage:${RST}
  packaging/install.sh [options]
  curl -fsSL https://raw.githubusercontent.com/202121000995/remote_pi/main/packaging/install.sh | bash
  curl -fsSL …/packaging/install.sh | bash -s -- --relay https://your-relay.example

${BOLD}Options:${RST}
  -h, --help            Show this help and exit
  --relay URL           Persist relay URL (http:// or https://).
                        Also reads \$REMOTE_PI_RELAY. wss:// is accepted and
                        stored as https:// (same as /remote-pi set-relay).
  --from PATH           Existing clone, pi-extension directory, or npm-pack
                        tarball (.tgz / .tar.gz). Default: this checkout, or
                        a clone of the fork into ~/.local/src/remote_pi.
  --skip-supervisor     Do not run \`remote-pi install\` (no systemd/launchd).
  --rebuild             Rebuild pi-extension even if dist/index.js exists

${BOLD}Environment:${RST}
  REMOTE_PI_RELAY       Same as --relay (persisted to ~/.pi/remote/config.json)
  REMOTE_PI_REPO        Git URL used when cloning (default: this fork)
  REMOTE_PI_REF         Git ref used when cloning (default: main)
  REMOTE_PI_SRC         Clone destination (default: ~/.local/src/remote_pi)
  REMOTE_PI_CWD         Folder that receives .pi/remote-pi/config.json
                        (default: \$HOME — avoids dirtying a git checkout)

${BOLD}Notes:${RST}
  • Never installs upstream ${BOLD}npm:remote-pi${RST}. Load this build with
    ${BOLD}pi -e <clone>/pi-extension/dist/index.js${RST} or the local-path
    install this script writes.
  • Pairing URI is printed by ${BOLD}/remote-pi pair${RST} (no TTY QR required).
    Paste it in the app sheet that starts with remotepi://pair?
  • Headless Linux without a keyring falls back to
    ${BOLD}~/.pi/remote/identity.json${RST} (mode 0600).
  • Idempotent: re-run does not break an existing pairing.

MIT. Read the script before piping it to bash.
EOF
}

RELAY_URL="${REMOTE_PI_RELAY:-}"
FROM_PATH=""
SKIP_SUPERVISOR=0
REBUILD=0

while [ "$#" -gt 0 ]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    --relay)
      [ "$#" -ge 2 ] || die "--relay requires a URL"
      RELAY_URL="$2"
      shift 2
      ;;
    --relay=*)
      RELAY_URL="${1#--relay=}"
      shift
      ;;
    --from)
      [ "$#" -ge 2 ] || die "--from requires a path"
      FROM_PATH="$2"
      shift 2
      ;;
    --from=*)
      FROM_PATH="${1#--from=}"
      shift
      ;;
    --skip-supervisor)
      SKIP_SUPERVISOR=1
      shift
      ;;
    --rebuild)
      REBUILD=1
      shift
      ;;
    --)
      shift
      break
      ;;
    -*)
      die "unknown option: $1 (try --help)"
      ;;
    *)
      die "unexpected argument: $1 (try --help)"
      ;;
  esac
done

# ── 0. OS detection ──────────────────────────────────────────────────────────

detect_os() {
  case "${OS:-}" in Windows_NT) echo "windows"; return ;; esac
  case "$(uname -s 2>/dev/null || echo unknown)" in
    Darwin)                 echo "macos" ;;
    Linux)                  echo "linux" ;;
    MINGW*|MSYS*|CYGWIN*)   echo "windows" ;;
    *)                      echo "unknown" ;;
  esac
}

OS="$(detect_os)"

if [ "$OS" = "windows" ]; then
  cat <<EOF
${BOLD}Remote Pi${RST} doesn't run natively on Windows.

Use ${BOLD}WSL${RST} and re-run this installer inside that Linux shell:

  ${DIM}# in PowerShell, one time:${RST}
  wsl --install

  ${DIM}# then, inside WSL:${RST}
  curl -fsSL https://raw.githubusercontent.com/202121000995/remote_pi/main/packaging/install.sh | bash

EOF
  exit 0
fi

if [ "$OS" = "unknown" ]; then
  die "unsupported platform '$(uname -s 2>/dev/null)'. Only macOS and Linux are supported."
fi

printf '%s\n' "${BOLD}Remote Pi (fork) installer${RST} ${DIM}(${OS}, user-space, no sudo)${RST}"
echo

# ── helpers ──────────────────────────────────────────────────────────────────

version_gte() {
  [ "$1" = "$2" ] && return 0
  [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -n1)" = "$2" ]
}

ensure_local_bin_on_path() {
  mkdir -p "$LOCAL_BIN"
  case ":$PATH:" in
    *":$LOCAL_BIN:"*) : ;;
    *) export PATH="$LOCAL_BIN:$PATH" ;;
  esac
}

npm_global_root() { npm root -g 2>/dev/null; }

NODE_FROM_NVM=0

configure_npm_prefix() {
  if [ "$NODE_FROM_NVM" = "1" ]; then
    unset npm_config_prefix 2>/dev/null || true
    return 0
  fi
  local groot gparent
  groot="$(npm_global_root)"
  [ -n "$groot" ] || return 0
  gparent="$(dirname "$groot")"
  while [ -n "$gparent" ] && [ ! -e "$gparent" ]; do gparent="$(dirname "$gparent")"; done
  if [ -n "$gparent" ] && [ ! -w "$gparent" ]; then
    info "system npm global root '$groot' is not writable — redirecting global installs to $USER_PREFIX (sudo-free)"
    export npm_config_prefix="$USER_PREFIX"
  fi
}

persist_path_in_rc() {
  case ":$PATH:" in *":$LOCAL_BIN:"*) : ;; *) return 0 ;; esac
  local rc=""
  case "${SHELL:-}" in
    */zsh)  rc="$HOME/.zshrc" ;;
    */bash) rc="$HOME/.bashrc" ;;
    *)      rc="$HOME/.profile" ;;
  esac
  [ -n "$rc" ] || return 0
  local line='export PATH="$HOME/.local/bin:$PATH"'
  if [ -f "$rc" ] && grep -qF '.local/bin' "$rc"; then
    return 0
  fi
  {
    printf '\n# Added by Remote Pi (fork) installer\n%s\n' "$line"
  } >> "$rc"
  warn "added ~/.local/bin to PATH in $rc — open a new shell or 'source $rc'"
}

is_remote_pi_pkg() {
  local json="$1/package.json"
  [ -f "$json" ] || return 1
  grep -qE '"name"[[:space:]]*:[[:space:]]*"remote-pi"' "$json"
}

# ── 1. Node ──────────────────────────────────────────────────────────────────

ensure_node() {
  step "Checking Node.js (need >= $MIN_NODE)"

  if command -v node >/dev/null 2>&1; then
    local have; have="$(node -v 2>/dev/null | sed 's/^v//')"
    if [ -n "$have" ] && version_gte "$have" "$MIN_NODE"; then
      case "$(command -v node)" in
        "$HOME/.nvm/"*) NODE_FROM_NVM=1; ok "using existing nvm Node v$have"; record "Node:       v$have (nvm)" ;;
        *)              NODE_FROM_NVM=0; ok "using system Node v$have";       record "Node:       v$have (system)" ;;
      esac
      return 0
    fi
    warn "system Node v${have:-?} is older than $MIN_NODE — installing a private one via nvm"
  else
    info "no Node found — installing a private one via nvm (user-space)"
  fi

  install_node_via_nvm
}

install_node_via_nvm() {
  unset npm_config_prefix 2>/dev/null || true
  export NVM_DIR="$HOME/.nvm"
  if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    info "installing nvm into $NVM_DIR"
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash >/dev/null
  else
    info "nvm already present in $NVM_DIR"
  fi

  # shellcheck disable=SC1091
  \. "$NVM_DIR/nvm.sh"

  if ! nvm ls "$NODE_LTS" >/dev/null 2>&1; then
    info "installing Node $NODE_LTS via nvm"
    nvm install "$NODE_LTS" >/dev/null
  fi
  nvm use "$NODE_LTS" >/dev/null

  command -v node >/dev/null 2>&1 || die "nvm install finished but 'node' is still not on PATH"
  local have; have="$(node -v | sed 's/^v//')"
  version_gte "$have" "$MIN_NODE" || die "installed Node v$have is still < $MIN_NODE"
  NODE_FROM_NVM=1
  ok "installed Node v$have via nvm"
  record "Node:       v$have (nvm)"
}

# ── 2. Pi coding agent ───────────────────────────────────────────────────────

ensure_pi() {
  step "Installing the Pi coding agent"

  if command -v pi >/dev/null 2>&1; then
    local v; v="$(pi --version 2>/dev/null | head -n1 || true)"
    ok "Pi already installed (${v:-version unknown}) — skipping"
    record "Pi:         ${v:-installed} (pre-existing)"
    return 0
  fi

  local groot; groot="$(npm_global_root)"
  if [ -n "$groot" ]; then
    local gparent; gparent="$(dirname "$groot")"
    while [ -n "$gparent" ] && [ ! -e "$gparent" ]; do gparent="$(dirname "$gparent")"; done
    if [ -n "$gparent" ] && [ ! -w "$gparent" ]; then
      die "npm global prefix '$groot' is not writable without sudo.
    This installer never uses sudo. Fix it user-space, then re-run:
      npm config set prefix \"\$HOME/.local\"
    (or install Node via nvm, which uses a writable prefix automatically)."
    fi
  fi

  info "npm install -g --prefix $USER_PREFIX $PI_PKG"
  npm install -g --prefix "$USER_PREFIX" "$PI_PKG" >/dev/null

  command -v pi >/dev/null 2>&1 || die "Pi installed but 'pi' is not on PATH (expected $LOCAL_BIN/pi)"
  local v; v="$(pi --version 2>/dev/null | head -n1 || true)"
  ok "installed Pi (${v:-version unknown})"
  record "Pi:         ${v:-installed} (${PI_PKG})"
}

# ── 3. This fork's pi-extension ──────────────────────────────────────────────

# Directory of this script when it is a real file (not `curl | bash`).
script_dir() {
  local src="${BASH_SOURCE[0]:-}"
  case "$src" in
    ""|/dev/fd/*|/proc/self/fd/*|bash|sh|-bash|-sh) return 1 ;;
  esac
  [ -f "$src" ] || return 1
  cd "$(dirname "$src")" && pwd
}

canonicalize() {
  local p="$1"
  if command -v realpath >/dev/null 2>&1; then
    realpath "$p"
  else
    (cd "$p" && pwd)
  fi
}

# Set EXT_DIR to the pi-extension package root (has package.json name=remote-pi).
resolve_from_tree() {
  local root="$1"
  if is_remote_pi_pkg "$root"; then
    EXT_DIR="$(canonicalize "$root")"
    return 0
  fi
  if is_remote_pi_pkg "$root/pi-extension"; then
    EXT_DIR="$(canonicalize "$root/pi-extension")"
    return 0
  fi
  return 1
}

extract_tarball() {
  local archive="$1"
  local dest="${REMOTE_PI_SRC:-$DEFAULT_SRC}-pkg"
  mkdir -p "$dest"
  # Fresh extract so a re-run with a new tarball replaces the old tree.
  find "$dest" -mindepth 1 -maxdepth 1 -exec rm -rf {} +
  info "extracting $archive → $dest"
  tar -xzf "$archive" -C "$dest"
  if resolve_from_tree "$dest"; then
    return 0
  fi
  local inner
  inner="$(find "$dest" -maxdepth 3 -name package.json -print -quit 2>/dev/null || true)"
  if [ -n "$inner" ] && resolve_from_tree "$(dirname "$inner")"; then
    return 0
  fi
  die "tarball did not contain this repo's pi-extension (package.json name=remote-pi).
    Looked under: $dest"
}

clone_fork() {
  local dest="${REMOTE_PI_SRC:-$DEFAULT_SRC}"
  local repo="${REMOTE_PI_REPO:-$DEFAULT_FORK_REPO}"
  local ref="${REMOTE_PI_REF:-$DEFAULT_FORK_REF}"
  if [ -d "$dest/.git" ] && resolve_from_tree "$dest"; then
    ok "using existing clone at $dest"
    return 0
  fi
  if [ -e "$dest" ] && [ ! -d "$dest/.git" ]; then
    die "clone destination '$dest' exists and is not a git checkout.
    Move it aside or set REMOTE_PI_SRC to an empty path."
  fi
  info "cloning $repo ($ref) → $dest"
  mkdir -p "$(dirname "$dest")"
  git clone --depth 1 --branch "$ref" "$repo" "$dest"
  resolve_from_tree "$dest" || die "clone at $dest has no pi-extension/"
}

resolve_extension_source() {
  step "Resolving this fork's pi-extension (not npm:remote-pi)"

  if [ -n "$FROM_PATH" ]; then
    [ -e "$FROM_PATH" ] || die "--from path not found: $FROM_PATH"
    case "$FROM_PATH" in
      *.tgz|*.tar.gz)
        extract_tarball "$FROM_PATH"
        ;;
      *)
        resolve_from_tree "$FROM_PATH" || die "--from '$FROM_PATH' is not this repo or its pi-extension/"
        ;;
    esac
    ok "using --from → $EXT_DIR"
    record "Source:     $EXT_DIR (--from)"
    return 0
  fi

  local here
  if here="$(script_dir)"; then
    local repo_root
    repo_root="$(cd "$here/.." && pwd)"
    if resolve_from_tree "$repo_root"; then
      ok "using checkout at $repo_root"
      record "Source:     $EXT_DIR (this clone)"
      return 0
    fi
  fi

  clone_fork
  ok "using clone → $EXT_DIR"
  record "Source:     $EXT_DIR (cloned fork)"
}

build_extension() {
  step "Building pi-extension at $EXT_DIR"
  PLUGIN_DIST="$EXT_DIR/dist/index.js"

  if [ "$REBUILD" != "1" ] && [ -f "$PLUGIN_DIST" ]; then
    ok "dist/index.js already present — skipping build (pass --rebuild to force)"
    record "Plugin:     this fork (pre-built $PLUGIN_DIST)"
    return 0
  fi

  (
    cd "$EXT_DIR"
    if command -v pnpm >/dev/null 2>&1; then
      info "pnpm install && pnpm build"
      pnpm install
      pnpm build
    else
      info "npm install && npm run build (pnpm not on PATH)"
      npm install
      npm run build
    fi
  )
  [ -f "$PLUGIN_DIST" ] || die "build finished but $PLUGIN_DIST is missing"
  local v
  v="$(node -p "require('$EXT_DIR/package.json').version" 2>/dev/null || true)"
  ok "built this fork's remote-pi${v:+ v$v} → $PLUGIN_DIST"
  record "Plugin:     this fork${v:+ v$v} ($PLUGIN_DIST)"
}

remove_upstream_npm_plugin() {
  # Upstream `npm:remote-pi` auto-runs gated tools. If both it and this
  # local-path install are enabled, Pi may load the published copy first.
  if ! command -v pi >/dev/null 2>&1; then
    return 0
  fi
  local listing
  listing="$(pi list 2>/dev/null || true)"
  if printf '%s\n' "$listing" | grep -qE 'npm:remote-pi'; then
    warn "removing upstream npm:remote-pi so this fork is the one Pi loads"
    pi remove npm:remote-pi >/dev/null 2>&1 || pi uninstall npm:remote-pi >/dev/null 2>&1 || \
      warn "could not remove npm:remote-pi — run: pi remove npm:remote-pi"
  fi
}

install_plugin_into_pi() {
  step "Registering the local extension with Pi"
  remove_upstream_npm_plugin
  info "pi install $EXT_DIR"
  if pi install "$EXT_DIR"; then
    ok "Pi will load this fork from $EXT_DIR"
    record "Pi install: local path $EXT_DIR"
  else
    warn "pi install <local-path> failed — you can still load the fork with:"
    warn "  pi -e $PLUGIN_DIST"
    record "Pi install: FAILED — use pi -e $PLUGIN_DIST"
  fi
}

# ── 4. Link the CLI ──────────────────────────────────────────────────────────

link_cli() {
  step "Linking remote-pi + pi-supervisord into $LOCAL_BIN"
  mkdir -p "$LOCAL_BIN"
  local target="$PLUGIN_DIST"
  local link="$LOCAL_BIN/$PLUGIN_NAME"
  local supervisor_src="$EXT_DIR/dist/bin/supervisord.js"
  local supervisor_link="$LOCAL_BIN/pi-supervisord"

  chmod +x "$target" 2>/dev/null || true
  [ -f "$supervisor_src" ] && chmod +x "$supervisor_src" 2>/dev/null || true

  if [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]; then
    ok "remote-pi already points at this build"
  else
    ln -sf "$target" "$link"
    ok "symlinked $link → $target"
  fi

  if [ -f "$supervisor_src" ]; then
    if [ -L "$supervisor_link" ] && [ "$(readlink "$supervisor_link")" = "$supervisor_src" ]; then
      ok "pi-supervisord already points at this build"
    else
      ln -sf "$supervisor_src" "$supervisor_link"
      ok "symlinked $supervisor_link → $supervisor_src"
    fi
  else
    warn "dist/bin/supervisord.js missing — supervisor CLI link skipped"
  fi
  record "CLI:        $link"
}

# ── 5. Relay persistence ─────────────────────────────────────────────────────

canonical_relay_url() {
  local raw="$1"
  case "$raw" in
    wss://*) printf '%s\n' "https://${raw#wss://}" ;;
    ws://*)  printf '%s\n' "http://${raw#ws://}" ;;
    *)       printf '%s\n' "$raw" ;;
  esac
}

persist_relay() {
  [ -n "$RELAY_URL" ] || return 0
  step "Persisting relay URL"
  local url
  url="$(canonical_relay_url "$RELAY_URL")"
  case "$url" in
    http://*|https://*) ;;
    *) die "relay URL must be http(s):// (or ws(s)://, which we store as http(s)://): $RELAY_URL" ;;
  esac
  if command -v remote-pi >/dev/null 2>&1; then
    info "remote-pi set-relay $url"
    remote-pi set-relay "$url"
  else
    # Same on-disk shape as saveConfig() — ~/.pi/remote/config.json {relay}.
    mkdir -p "$HOME/.pi/remote"
    local cfg="$HOME/.pi/remote/config.json"
    if command -v node >/dev/null 2>&1; then
      node -e '
        const fs = require("fs");
        const p = process.argv[1];
        const url = process.argv[2];
        let cur = {};
        try { cur = JSON.parse(fs.readFileSync(p, "utf8")); } catch {}
        if (!cur || typeof cur !== "object" || Array.isArray(cur)) cur = {};
        cur.relay = url;
        fs.writeFileSync(p, JSON.stringify(cur, null, 2) + "\n");
      ' "$cfg" "$url"
    else
      printf '{\n  "relay": "%s"\n}\n' "$url" > "$cfg"
    fi
    ok "wrote $cfg"
  fi
  record "Relay:      $url"
}

# ── 6. Supervisor ────────────────────────────────────────────────────────────

install_supervisor() {
  if [ "$SKIP_SUPERVISOR" = "1" ]; then
    step "Supervisor skipped (--skip-supervisor)"
    record "Supervisor: skipped"
    return 0
  fi
  step "Installing the user supervisor service ($OS)"
  if [ "$OS" = "linux" ]; then
    info "Linux: remote-pi install writes a systemd --user unit"
  else
    info "macOS: remote-pi install writes a launchd GUI agent (same command)"
  fi
  if command -v remote-pi >/dev/null 2>&1 && remote-pi install; then
    ok "supervisor installed and activated"
    record "Supervisor: installed (${OS})"
  else
    warn "supervisor install reported an error — see the output above"
    warn "you can re-run it any time with:  remote-pi install"
    record "Supervisor: FAILED — re-run 'remote-pi install'"
  fi
  if [ "$OS" = "linux" ] && command -v loginctl >/dev/null 2>&1; then
    local linger
    linger="$(loginctl show-user "${USER:-$(id -un)}" -p Linger --value 2>/dev/null || true)"
    if [ "$linger" != "yes" ]; then
      warn "systemd --user units stop when you log out of SSH."
      warn "On a VPS, enable lingering (may need root):  loginctl enable-linger $USER"
    fi
  fi
}

# ── 7. Local config (skip the interactive wizard) ────────────────────────────

ensure_local_config() {
  # Per-cwd file at <cwd>/.pi/remote-pi/config.json. Default cwd is $HOME so
  # running this from a git checkout does not dirty the tree. Override with
  # REMOTE_PI_CWD when the daemon should live in a project folder.
  local cwd="${REMOTE_PI_CWD:-$HOME}"
  local cfg="$cwd/.pi/remote-pi/config.json"
  if [ -f "$cfg" ]; then
    ok "local agent config already present at $cfg — leaving it alone"
    return 0
  fi
  local name
  name="$(basename "$cwd")"
  [ -n "$name" ] && [ "$name" != "/" ] && [ "$name" != "." ] || name="agent"
  mkdir -p "$(dirname "$cfg")"
  printf '{\n  "agent_name": "%s",\n  "auto_start_relay": true\n}\n' "$name" > "$cfg"
  ok "wrote first-run config at $cfg (skips the interactive wizard)"
}

# ── 8. Next steps ────────────────────────────────────────────────────────────

print_next_steps() {
  echo
  printf '%s\n' "${GRN}${BOLD}This fork of Remote Pi is installed.${RST} On disk:"
  echo
  local entry
  for entry in "${SUMMARY[@]}"; do
    printf '    %s\n' "$entry"
  done
  echo
  printf '%s\n' "${BOLD}Load THIS extension — do not use upstream npm:remote-pi:${RST}"
  cat <<EOF

    ${BOLD}pi -e ${PLUGIN_DIST}${RST}

    (the installer also ran ${BOLD}pi install ${EXT_DIR}${RST} so a plain
    ${BOLD}pi${RST} should pick it up. If you ever see the published package
    again, run:  ${BOLD}pi remove npm:remote-pi${RST})

EOF
  printf '%s\n' "${BOLD}Pair over SSH (copy-paste URI — QR is useless here):${RST}"
  cat <<EOF

    1. In this shell (TTY or not):

         ${BOLD}pi -e ${PLUGIN_DIST}${RST}
         ${BOLD}/remote-pi pair${RST}

    2. Copy the line that starts with ${BOLD}remotepi://pair?${RST}
       The URI is always printed; a TTY QR is not required.
    3. In the Remote Pi app: pairing screen → paste-code sheet → paste → Pair.

    Re-running this installer does ${BOLD}not${RST} reset an existing pairing
    (peers.json / identity stay put).

${BOLD}Headless Linux identity:${RST}
    If there is no GNOME Keyring / KWallet / D-Bus session, the Pi-key is
    stored at ${BOLD}~/.pi/remote/identity.json${RST} with mode ${BOLD}0600${RST}.
    That is expected on a VPS. Keep the file; deleting it orphans pairings.

${BOLD}Relay:${RST}
    Community default, Tailscale hostname, or your self-hosted relay are all
    fine. Persist with ${BOLD}--relay${RST} / ${BOLD}REMOTE_PI_RELAY${RST} or
    later:  ${BOLD}remote-pi set-relay https://…${RST}

EOF
  if [ -f "$HOME/.pi/remote/peers.json" ]; then
    ok "existing pairing file ~/.pi/remote/peers.json left untouched"
  fi
  case ":$PATH:" in
    *":$LOCAL_BIN:"*) : ;;
    *) warn "Open a new shell (or 'source' your shell rc) so 'pi' and 'remote-pi' are on PATH." ;;
  esac
}

# ── main ─────────────────────────────────────────────────────────────────────

EXT_DIR=""
PLUGIN_DIST=""

main() {
  ensure_local_bin_on_path
  ensure_node
  configure_npm_prefix
  ensure_pi
  resolve_extension_source
  build_extension
  install_plugin_into_pi
  link_cli
  persist_relay
  install_supervisor
  persist_path_in_rc
  ensure_local_config
  print_next_steps
}

main "$@"

#!/bin/sh
# Creates a new Laby Client addon from the addon template, ready for AI coding agents.
# Usage: curl -fsSL https://dev.labymod.net/new-addon.sh | sh
#
# Installs what is missing (JDK 25, Node.js, Git) with Homebrew, apt, dnf or pacman after asking, downloads the addon
# template, renames it to your addon and sets up the MCP servers, skills and AGENTS.md for Claude Code, Codex and
# Gemini CLI.

set -eu

TEMPLATE_URL="${LABY_ADDON_TEMPLATE:-https://github.com/LabyMod/addon-template/archive/refs/heads/master.tar.gz}"

# With curl | sh, stdin is this script, so answers come from the terminal. Opened once as fd 3: reopening
# /dev/stdin for every question would start a redirected file from the top again.
if [ -r /dev/tty ] && (exec </dev/tty) 2>/dev/null; then
  exec 3</dev/tty
else
  exec 3<&0
fi

step() {
  printf '\n\033[36m==> %s\033[0m\n' "$1"
}

fail() {
  printf '\033[31m%s\033[0m\n' "$1" >&2
  exit 1
}

# ask <question> <default>; the answer ends up in $ANSWER
ask() {
  if [ -n "$2" ]; then
    printf '%s [%s]: ' "$1" "$2"
  else
    printf '%s: ' "$1"
  fi
  read -r ANSWER <&3 || fail 'No input left to answer the question.'
  if [ -z "$ANSWER" ]; then
    ANSWER="$2"
  fi
}

confirm() {
  printf '%s [Y/n]: ' "$1"
  read -r reply <&3 || fail 'No input left to answer the question.'
  case "$reply" in
    ""|y*|Y*|j*|J*) return 0 ;;
    *) return 1 ;;
  esac
}

java_major() {
  if ! command -v java >/dev/null 2>&1; then
    echo 0
    return
  fi
  java -version 2>&1 | sed -n 's/.*version "\(1\.\)\{0,1\}\([0-9]*\).*/\2/p' | head -n 1
}

node_major() {
  if ! command -v node >/dev/null 2>&1; then
    echo 0
    return
  fi
  node --version | sed -n 's/^v\([0-9]*\).*/\1/p'
}

# install_package <brew formula> <apt package> <dnf package> <pacman package> <label>
install_package() {
  if command -v brew >/dev/null 2>&1; then
    case "$1" in
      cask:*) brew install --cask "${1#cask:}" ;;
      *) brew install "$1" ;;
    esac
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install -y "$2"
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y "$3"
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --noconfirm $4
  else
    fail "No supported package manager found. Install $5 yourself, then run this script again."
  fi
}

# On macOS java is a stub that follows JAVA_HOME, so point it at the JDK 25 Homebrew just installed
use_installed_jdk() {
  if [ -x /usr/libexec/java_home ]; then
    if home=$(/usr/libexec/java_home -v 25 2>/dev/null); then
      JAVA_HOME="$home"
      PATH="$home/bin:$PATH"
      export JAVA_HOME PATH
    fi
  fi
}

printf '\033[32mLaby Client addon setup\033[0m\n'
echo 'This creates a new addon project from the official template and prepares it for AI coding agents.'

step 'Checking prerequisites'
if [ "$(java_major)" -lt 25 ] 2>/dev/null || [ -z "$(java_major)" ]; then
  echo 'JDK 25 or newer was not found. Addons need it because Minecraft 26.1 and later run on Java 25.'
  confirm 'Install JDK 25 now?' || fail 'JDK 25 is required. Install it from https://adoptium.net and run this script again.'
  # Older Debian and Ubuntu releases don't package JDK 25 yet; send those users to Adoptium instead of a raw apt error
  install_package cask:temurin@25 openjdk-25-jdk java-25-openjdk-devel jdk25-openjdk 'JDK 25' \
    || fail 'Your package manager has no JDK 25. Install it from https://adoptium.net and run this script again.'
  use_installed_jdk
  [ "$(java_major)" -ge 25 ] 2>/dev/null || fail 'JDK 25 was installed, but this shell still finds an older Java. Open a new terminal and run the script again.'
fi
echo "Java $(java_major): ok"

if [ "$(node_major)" -lt 18 ] 2>/dev/null || [ -z "$(node_major)" ]; then
  echo 'Node.js 18 or newer runs the laby-client tool that lets AI agents control the game. It was not found.'
  if confirm 'Install Node.js now?'; then
    install_package node nodejs nodejs 'nodejs npm' 'Node.js'
  else
    echo 'Skipped. Everything else works; the agent just cannot drive the running client.'
  fi
fi
if [ "$(node_major)" -ge 18 ] 2>/dev/null; then
  echo "Node.js $(node_major): ok"
fi

if ! command -v git >/dev/null 2>&1; then
  echo 'Git is recommended: AI agents use it to review and undo their changes. It was not found.'
  if confirm 'Install Git now?'; then
    install_package git git git git 'Git'
  fi
fi

step 'About your addon'
NAME=""
while [ -z "$NAME" ]; do
  ask 'Addon name, shown in the addon store (e.g. Chat Tools)' ''
  NAME="$ANSWER"
done

DEFAULT_NAMESPACE=$(printf '%s' "$NAME" | tr 'A-Z' 'a-z' | tr -cd 'a-z0-9')
ask 'Namespace, a unique id (lowercase letters, digits, _ . -)' "$DEFAULT_NAMESPACE"
NAMESPACE="$ANSWER"
while ! printf '%s' "$NAMESPACE" | grep -Eq '^[a-z0-9_.-]+$' || [ "$NAMESPACE" = example ]; do
  ask 'Use only lowercase letters, digits, _ . - (and not "example")' "$DEFAULT_NAMESPACE"
  NAMESPACE="$ANSWER"
done

ask 'Author' "${USER:-$(whoami)}"
AUTHOR="$ANSWER"
AUTHOR_PART=$(printf '%s' "$AUTHOR" | tr 'A-Z' 'a-z' | tr -cd 'a-z0-9')
case "$AUTHOR_PART" in
  ""|[0-9]*) AUTHOR_PART=addon ;;
esac
NAMESPACE_PART=$(printf '%s' "$NAMESPACE" | tr -cd 'a-z0-9_')
case "$NAMESPACE_PART" in
  [0-9]*) NAMESPACE_PART="_$NAMESPACE_PART" ;;
esac
DEFAULT_PACKAGE="com.$AUTHOR_PART.$NAMESPACE_PART"
ask 'Main Java package' "$DEFAULT_PACKAGE"
PACKAGE="$ANSWER"
while ! printf '%s' "$PACKAGE" | grep -Eq '^[a-z_][a-z0-9_]*(\.[a-z_][a-z0-9_]*)*$' || printf '%s' "$PACKAGE" | grep -Eq '^org\.example(\.|$)'; do
  ask 'Use lowercase words separated by dots, e.g. com.yourname.chattools' "$DEFAULT_PACKAGE"
  PACKAGE="$ANSWER"
done

ask 'Create the project in' "$(pwd)/$NAMESPACE"
DIRECTORY="$ANSWER"
[ ! -e "$DIRECTORY" ] || fail "$DIRECTORY already exists. Choose another folder or remove it first."

step 'Downloading the addon template'
TEMP=$(mktemp -d)
trap 'rm -rf "$TEMP"' EXIT
if [ -f "$TEMPLATE_URL" ]; then
  cp "$TEMPLATE_URL" "$TEMP/template.tar.gz"
else
  curl -fsSL "$TEMPLATE_URL" -o "$TEMP/template.tar.gz"
fi
mkdir "$TEMP/unpacked"
tar -xzf "$TEMP/template.tar.gz" -C "$TEMP/unpacked"
mkdir -p "$(dirname "$DIRECTORY")"
mv "$TEMP/unpacked/"* "$DIRECTORY"

cd "$DIRECTORY"
chmod +x gradlew
step 'Renaming the template (the first run downloads Minecraft and LabyMod, this takes a few minutes)'
./gradlew initAddon --name "$NAME" --namespace "$NAMESPACE" --package "$PACKAGE" --author "$AUTHOR" \
  || fail 'initAddon failed, see the output above.'

step 'Setting up the AI tools'
./gradlew setupMcpServer || fail 'setupMcpServer failed, see the output above.'

if command -v git >/dev/null 2>&1; then
  git init --quiet
  git add --all
  if git config user.name >/dev/null && git config user.email >/dev/null; then
    git commit --quiet -m "Create $NAME from the Laby addon template"
  fi
fi

step "Done: $DIRECTORY"
echo 'Start your AI agent in the project folder and describe the addon you want to build:'
echo "  cd \"$DIRECTORY\""
AGENT=""
for candidate in claude codex gemini; do
  if [ -z "$AGENT" ] && command -v "$candidate" >/dev/null 2>&1; then
    AGENT="$candidate"
  fi
done
if [ -n "$AGENT" ]; then
  echo "  $AGENT"
else
  echo '  then run Claude Code (claude), Codex (codex) or Gemini CLI (gemini)'
fi
echo 'AGENTS.md tells the agent how this project works.'
NEWEST=$(sed -n 's/^net\.labymod\.minecraft-versions=//p' gradle.properties | tr ';' '\n' | tail -n 1 | tr -d '\r')
echo
echo "Start the game with: ./gradlew :game-runner:client_v${NEWEST:-<version>}"
echo 'To debug it, open the folder in IntelliJ IDEA.'

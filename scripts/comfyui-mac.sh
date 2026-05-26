#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────
# ComfyUI nativo para Apple Silicon (Mac M1/M2/M3/M4).
# Se instala dentro del repo en creator-data/comfyui-native/ y comparte
# modelos con la versión Docker (creator-data/comfyui/models/).
#
# Uso:
#   ./scripts/comfyui-mac.sh install      Instala ComfyUI nativo
#   ./scripts/comfyui-mac.sh start        Arranca el servidor (Ctrl+C para parar)
#   ./scripts/comfyui-mac.sh update       Actualiza ComfyUI a la última versión
#   ./scripts/comfyui-mac.sh uninstall    Borra la instalación (modelos a salvo)
# ──────────────────────────────────────────────────────────────────────────

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NATIVE_DIR="$REPO_ROOT/creator-data/comfyui-native"
COMFY_DIR="$NATIVE_DIR/ComfyUI"
VENV_DIR="$NATIVE_DIR/venv"
SHARED_MODELS="$REPO_ROOT/creator-data/comfyui/models"

color() { printf "\033[%sm%s\033[0m\n" "$1" "$2"; }
info()  { color "1;34" "[ask] $1"; }
ok()    { color "1;32" "[ok]  $1"; }
warn()  { color "1;33" "[!]   $1"; }
err()   { color "1;31" "[err] $1"; }

check_requirements() {
  command -v git >/dev/null || { err "git no instalado. Instala Xcode Command Line Tools: xcode-select --install"; exit 1; }

  # PyTorch publica wheels para versiones concretas de Python. Buscamos una compatible
  # (3.12 es el sweet spot ahora mismo). Si el usuario pasa PYTHON=..., respetamos eso.
  if [ -n "${PYTHON:-}" ]; then
    PY_BIN="$PYTHON"
  else
    for candidate in python3.12 python3.11 python3.13 python3.10 python3; do
      if command -v "$candidate" >/dev/null; then
        PY_BIN="$candidate"
        break
      fi
    done
  fi

  [ -n "${PY_BIN:-}" ] || { err "No encuentro Python 3. Instala con: brew install python@3.12"; exit 1; }
  command -v "$PY_BIN" >/dev/null || { err "El Python indicado ($PY_BIN) no existe."; exit 1; }

  PY_VERSION=$("$PY_BIN" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')
  PY_MAJOR=$(echo "$PY_VERSION" | cut -d. -f1)
  PY_MINOR=$(echo "$PY_VERSION" | cut -d. -f2)

  if [ "$PY_MAJOR" -lt 3 ] || { [ "$PY_MAJOR" -eq 3 ] && [ "$PY_MINOR" -lt 10 ]; }; then
    err "Necesitas Python 3.10 o superior. Tienes $PY_VERSION."
    exit 1
  fi

  if [ "$PY_MAJOR" -eq 3 ] && [ "$PY_MINOR" -ge 14 ]; then
    err "Python $PY_VERSION es demasiado nuevo: PyTorch aún no publica wheels."
    err "Instala una versión compatible con: brew install python@3.12"
    err "O fuerza una versión: PYTHON=python3.12 $0 install"
    exit 1
  fi

  ok "Requisitos cumplidos (git, $PY_BIN -> Python $PY_VERSION)."
}

cmd_install() {
  check_requirements

  if [ -d "$COMFY_DIR" ]; then
    warn "ComfyUI ya está instalado en $COMFY_DIR. Usa 'update' para actualizar o 'uninstall' para borrar."
    exit 0
  fi

  mkdir -p "$NATIVE_DIR"

  info "Clonando ComfyUI..."
  git clone https://github.com/comfyanonymous/ComfyUI.git "$COMFY_DIR"

  info "Creando entorno virtual de Python aislado ($PY_BIN)..."
  "$PY_BIN" -m venv "$VENV_DIR"
  # shellcheck disable=SC1091
  source "$VENV_DIR/bin/activate"
  pip install --upgrade pip wheel

  info "Instalando PyTorch con soporte Metal (MPS)..."
  pip install --pre torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/nightly/cpu

  info "Instalando dependencias de ComfyUI..."
  pip install -r "$COMFY_DIR/requirements.txt"

  info "Configurando ruta compartida de modelos..."
  mkdir -p "$SHARED_MODELS"/{checkpoints,unet,vae,clip,loras,controlnet,embeddings,upscale_models}
  cat > "$COMFY_DIR/extra_model_paths.yaml" <<EOF
ai-survival-kit:
  base_path: $SHARED_MODELS
  checkpoints: checkpoints/
  unet: unet/
  vae: vae/
  clip: clip/
  loras: loras/
  controlnet: controlnet/
  embeddings: embeddings/
  upscale_models: upscale_models/
EOF

  ok "Instalación completa."
  echo
  echo "Para arrancar:   ./scripts/comfyui-mac.sh start"
  echo "Abre luego:      http://localhost:8188"
  echo "Modelos en:      $SHARED_MODELS"
}

cmd_start() {
  [ -d "$COMFY_DIR" ] || { err "ComfyUI no está instalado. Ejecuta primero: ./scripts/comfyui-mac.sh install"; exit 1; }
  info "Arrancando ComfyUI en http://localhost:8188 (Ctrl+C para parar)..."
  # shellcheck disable=SC1091
  source "$VENV_DIR/bin/activate"
  cd "$COMFY_DIR"
  python main.py --listen 127.0.0.1 --port 8188
}

cmd_update() {
  [ -d "$COMFY_DIR" ] || { err "ComfyUI no está instalado."; exit 1; }
  info "Actualizando ComfyUI..."
  cd "$COMFY_DIR"
  git pull
  # shellcheck disable=SC1091
  source "$VENV_DIR/bin/activate"
  pip install -r requirements.txt --upgrade
  ok "Actualizado."
}

cmd_uninstall() {
  [ -d "$NATIVE_DIR" ] || { warn "No hay nada que desinstalar."; exit 0; }
  warn "Esto va a borrar $NATIVE_DIR"
  warn "Tus modelos en $SHARED_MODELS NO se tocan."
  read -r -p "¿Seguro? [y/N] " confirm
  if [[ "$confirm" =~ ^[yY]$ ]]; then
    rm -rf "$NATIVE_DIR"
    ok "Desinstalado. Cero rastro."
  else
    info "Cancelado."
  fi
}

case "${1:-}" in
  install)   cmd_install ;;
  start)     cmd_start ;;
  update)    cmd_update ;;
  uninstall) cmd_uninstall ;;
  *)
    echo "Uso: $0 {install|start|update|uninstall}"
    exit 1
    ;;
esac

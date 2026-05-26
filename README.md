# AI Survival Kit

Stack modular de IA local desplegable con `docker compose up`. Ollama, Open WebUI, faster-whisper, Kokoro TTS, ComfyUI y un proxy compatible con la API de OpenAI (LiteLLM) para reemplazar servicios cloud sin tocar tu código.

Pensado para tener autonomía frente a cambios de precio, baneos o discontinuación de servicios externos. La historia detrás del proyecto está en [post.md](post.md).

---

## Características

- **LLM local** con [Ollama](https://ollama.com) + UI tipo ChatGPT con [Open WebUI](https://github.com/open-webui/open-webui).
- **Transcripción de audio** (STT) con [faster-whisper-server](https://github.com/fedirz/faster-whisper-server) — API compatible con OpenAI.
- **Síntesis de voz** (TTS) con [Kokoro](https://github.com/remsky/Kokoro-FastAPI) — API compatible con OpenAI.
- **Generación de imagen y vídeo** con [ComfyUI](https://github.com/comfyanonymous/ComfyUI) (Docker para NVIDIA, script nativo para Apple Silicon).
- **Proxy unificado** con [LiteLLM](https://github.com/BerriAI/litellm) que expone todo el stack en `http://localhost:4000/v1` con la misma API que OpenAI.

---

## Perfiles

| Perfil | Servicios | Casos de uso |
|--------|-----------|--------------|
| `basic` | Ollama, Open WebUI | Chat local, programación con [Continue.dev](https://continue.dev), RAG básico |
| `creator` | + faster-whisper, Kokoro TTS | Transcripción, síntesis de voz |
| `image` | + ComfyUI (Docker, requiere NVIDIA) | Generación de imagen y vídeo |
| `bunker` | + LiteLLM | Proxy compatible con OpenAI para apps en producción |

Los perfiles son acumulativos en cuanto a dependencias (`bunker` arranca también `basic` y `creator`).

---

## Requisitos

- Docker y Docker Compose
- 8 GB de RAM mínimo (16 GB recomendado)
- Disco libre en Docker (no en el sistema):
  - `basic`: 15 GB
  - `basic` + `creator`: 25-30 GB
  - Con `image` y modelos de imagen/vídeo: 60-120 GB

Opcional según perfil:
- **NVIDIA GPU + [nvidia-container-toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)** para acelerar Ollama y ComfyUI en Linux/Windows.
- **Python 3.10-3.13 + git** en el host si vas a usar ComfyUI nativo en Mac (lo verifica el script).

---

## Quickstart

```bash
git clone https://github.com/ablancodev/ai-survival-kit.git
cd ai-survival-kit
cp .env.example .env
docker compose --profile basic up -d
```

La primera vez tarda unos minutos descargando el modelo por defecto (`qwen2.5:3b`, ~2 GB). Sigue el progreso con:

```bash
docker compose logs -f model-puller
```

Cuando termine: [http://localhost:3000](http://localhost:3000).

---

## Uso por perfil

### `basic` — Chat local

```bash
docker compose --profile basic up -d
```

| Servicio | URL | Para qué |
|----------|-----|----------|
| Open WebUI | http://localhost:3000 | UI tipo ChatGPT |
| Ollama API | http://localhost:11434 | API de modelos |

### `creator` — Audio (STT + TTS)

```bash
docker compose --profile creator up -d
```

| Servicio | URL | API |
|----------|-----|-----|
| faster-whisper-server | http://localhost:8001 | `POST /v1/audio/transcriptions` (compatible OpenAI) |
| Kokoro TTS | http://localhost:8002 | `POST /v1/audio/speech` (compatible OpenAI) |

Ejemplos:

```bash
# Transcribir un audio
curl -X POST http://localhost:8001/v1/audio/transcriptions \
  -F "file=@audio.mp3" \
  -F "model=Systran/faster-whisper-small"

# Generar voz
curl -X POST http://localhost:8002/v1/audio/speech \
  -H "Content-Type: application/json" \
  -d '{"model":"kokoro","voice":"af_bella","input":"Hola"}' \
  --output voz.mp3
```

### `image` — Generación de imagen y vídeo

Dos caminos según hardware:

**Linux / Windows con GPU NVIDIA:**

```bash
docker compose --profile image up -d
# http://localhost:8188
```

Requiere descomentar el bloque `deploy:` de NVIDIA en `docker-compose.yml`.

**Mac Apple Silicon** (Docker no expone Metal):

```bash
./scripts/comfyui-mac.sh install
./scripts/comfyui-mac.sh start
# http://localhost:8188
```

Otros subcomandos: `update`, `uninstall`. La instalación vive en `creator-data/comfyui-native/` (gitignored) y comparte modelos con la versión Docker.

Los modelos no se descargan automáticamente. Ver [docs/creator-models.md](docs/creator-models.md) para links de FLUX, SDXL y modelos de vídeo.

> **Cuidado:** ComfyUI incluye una galería de templates "API" (Seedance, Kling, Veo, Flux Pro...) que llaman a servicios de pago. Usa solo workflows con nodos `Load Checkpoint`/`KSampler`/etc. para 100% local. La cuenta de Comfy.org no es necesaria.

### `bunker` — Proxy OpenAI-compatible

```bash
docker compose --profile bunker up -d
```

LiteLLM en `http://localhost:4000/v1` con la misma API que OpenAI. Mapeos definidos en `litellm/config.yaml`:

| Cliente pide | Se enruta a |
|--------------|-------------|
| `gpt-4o`, `gpt-4-turbo` | Ollama `qwen2.5:7b` |
| `gpt-4o-mini`, `gpt-3.5-turbo` | Ollama `qwen2.5:3b` |
| `whisper-1` | faster-whisper-server |
| `tts-1`, `tts-1-hd` | Kokoro |

Migración de código:

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:4000/v1",
    api_key="not-needed",
)
resp = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Hola"}],
)
```

---

## Configuración

Todas las variables están documentadas en [`.env.example`](.env.example). Las más relevantes:

| Variable | Por defecto | Qué hace |
|----------|-------------|----------|
| `DEFAULT_MODEL` | `qwen2.5:3b` | Modelo de Ollama descargado al arrancar |
| `WHISPER_MODEL` | `Systran/faster-whisper-small` | Tamaño del modelo Whisper |
| `OLLAMA_KEEP_ALIVE` | `5m` | Tiempo de modelo en RAM tras última petición |
| `WEBUI_AUTH` | `true` | Login en Open WebUI |

### Cambiar modelo por defecto de Ollama

| Hardware | Recomendado |
|----------|-------------|
| CPU / 8 GB RAM | `qwen2.5:3b` |
| 16 GB RAM o GPU 6 GB | `qwen2.5:7b` |
| GPU 12 GB+ | `qwen2.5:14b` |
| Coding | `qwen2.5-coder:7b` |

Edita `DEFAULT_MODEL` en `.env` antes del primer arranque, o descarga modelos extra desde Open WebUI (`Settings → Models`).

---

## Notas por plataforma

- **macOS (Apple Silicon):** Docker no expone Metal. Para Ollama, instala la app nativa desde [ollama.com/download](https://ollama.com/download) y pon `OLLAMA_BASE_URL=http://host.docker.internal:11434` en `.env`. Para ComfyUI, usa el script nativo.
- **Linux con NVIDIA:** instala [`nvidia-container-toolkit`](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) y descomenta los bloques `deploy:` correspondientes en `docker-compose.yml`.
- **Windows:** usa WSL2 + Docker Desktop. Para GPU NVIDIA, sigue [esta guía](https://docs.nvidia.com/cuda/wsl-user-guide/).

---

## Estructura del repo

```
ai-survival-kit/
├── docker-compose.yml      # Servicios organizados por profiles
├── .env.example            # Configuración
├── litellm/
│   └── config.yaml         # Mapeo modelos OpenAI → backends locales
├── docs/
│   └── creator-models.md   # Guía de descarga de modelos de imagen/vídeo
├── scripts/
│   └── comfyui-mac.sh      # Instalador ComfyUI nativo (Apple Silicon)
├── creator-data/           # (gitignored) modelos, outputs, instalación nativa
├── post.md                 # La historia y filosofía del proyecto
└── README.md
```

---

## Troubleshooting

**`no space left on device`**
Es el disco virtual de Docker, no el del sistema. Docker Desktop → Settings → Resources → Disk image size. O `docker system prune -a`.

**Open WebUI no encuentra modelos**
Espera a que `model-puller` termine: `docker compose logs -f model-puller`.

**Ollama lento en Mac dentro de Docker**
Instala Ollama nativo (usa Metal). Detén el contenedor `ollama` y apunta Open WebUI al host: `OLLAMA_BASE_URL=http://host.docker.internal:11434`.

**ComfyUI tarda eternamente en generar una imagen**
Estás en CPU. Necesitas GPU NVIDIA expuesta al contenedor, o ComfyUI nativo en Mac.

**ComfyUI dice "model not found"**
No has descargado modelos. Ver [docs/creator-models.md](docs/creator-models.md).

**ComfyUI me pide pagar al ejecutar un workflow**
Es un workflow "API" (Seedance, Kling, Veo, Flux Pro...) que llama a servicios de pago. Cierra y abre un template local (`SDXL Simple`, `Flux Schnell`, sin "API" en el nombre).

**La primera petición a Whisper tarda mucho**
Está descargando el modelo. Las siguientes son inmediatas. `docker compose logs -f whisper`.

**Kokoro no encuentra la voz**
Lista voces disponibles: `curl http://localhost:8002/v1/audio/voices`.

---

## Roadmap

- [x] Perfil `basic` — Ollama + Open WebUI
- [x] Perfil `creator` — faster-whisper + Kokoro
- [x] Perfil `image` (Docker NVIDIA) + script nativo para Apple Silicon
- [x] Perfil `bunker` — LiteLLM
- [ ] Extensiones del búnker: AnythingLLM (RAG dedicado) + n8n (agentes 24/7)
- [ ] Script `install-model-pack` para descargas guiadas
- [ ] Benchmarks por tipo de hardware
- [ ] Backups automáticos
- [ ] Modo `low-power` (Raspberry Pi, mini PCs)

---

## Licencia

MIT.

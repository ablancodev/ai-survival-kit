# AI Survival Kit

> Para cuando los grandes cierren el grifo.
> Un kit de supervivencia para el día que ChatGPT cueste 200€/mes, capen tu API key sin avisar, o decidan que tu caso de uso "viola las políticas".

```
   PROTOCOLO DE EMERGENCIA IA
   ───────────────────────────────────
   [x] Generador eléctrico        ->  Ollama
   [x] Linterna                   ->  Open WebUI
   [x] Comida enlatada            ->  Qwen 2.5
   [x] Radio de onda corta        ->  Whisper (escuchar)
   [x] Megáfono                   ->  Kokoro TTS (hablar)
   [x] Taller de imágenes (*)     ->  ComfyUI (FLUX / SDXL)
   [x] Adaptador universal        ->  LiteLLM (todo habla OpenAI)
   [x] Búnker bien equipado       ->  listo

   (*) solo con GPU NVIDIA. En Mac usa ComfyUI nativo.
```

---

## ¿Qué es esto?

Imagina que mañana:

- **Se va la luz** — OpenAI sube precios un 10x de la noche a la mañana.
- **Llegan los zombis** — tu cuenta queda baneada por "uso sospechoso".
- **Erupciona el volcán** — la API que usaba tu negocio se discontinúa con 30 días de aviso.
- **Se acaba el agua** — tu país decide regular y bloquear servicios extranjeros.

¿Qué haces? ¿Lloras? ¿Pagas? ¿Migras a mano 47 integraciones?

No. Bajas al sótano, enciendes el generador, y sigues trabajando.

Este repo **es ese sótano**.

---

## La filosofía

> **No reemplaces a OpenAI. Haz que OpenAI sea reemplazable.**
>
> **Tu objetivo no es casarte con una IA. Es poder divorciarte en cualquier momento.**
>
> **Tu generador eléctrico de IA es tener al menos un LLM decente funcionando localmente.**

La IA ya es **infraestructura crítica personal**. Igual que tienes:

- copias de seguridad de tus fotos,
- un NAS en casa,
- un gestor de contraseñas,
- una linterna en el cajón...

...tienes que tener **modelos locales** y **workflows portables**. Punto.

---

## ¿Para qué te sirve esto en el día a día?

No es solo "por si acaso". Es algo que **usas todos los días** y, de paso, te blinda. Algunos escenarios reales:

### Tu copiloto de programación
Se cae Copilot, GitHub sube el plan, o tu empresa prohíbe mandar código a terceros. Con `qwen2.5-coder:7b` corriendo local tienes autocompletado, refactors, explicación de código y debugging — sin que una sola línea salga de tu máquina. Funciona con [Continue.dev](https://continue.dev/) en VS Code o JetBrains apuntando a tu Ollama.

### El SaaS que tienes en producción
Tu app usa la API de OpenAI/Anthropic y de repente: precio x5, rate limits nuevos, o tu modelo favorito se discontinúa. Con **LiteLLM** (perfil `bunker`) cambias `base_url` a `http://localhost:4000/v1` y tu código sigue llamando a `gpt-4o` exactamente igual — pero por detrás está tu Ollama local. Cero cambios de lógica, cero downtime. **Esta es la pieza más importante del kit si vives de la IA.**

### Tu día a día normal
Resumir un PDF largo. Reescribir un email. Traducir algo. Pedirle ideas. Lluvia de ideas para un proyecto. Explicarte un concepto que no entiendes. Todo eso que ahora haces en ChatGPT — pero en `localhost:3000`, sin contador de mensajes, sin que tus prompts entrenen el siguiente modelo de nadie.

### Cosas del trabajo que no deberían salir de tu empresa
Contratos. Datos de clientes. Documentación interna. Código propietario. Información médica. Conversaciones de RRHH. Nada de eso debería pasar por una API externa. Con el perfil `bunker` + RAG local, tu IA conoce tus documentos sin que nadie más los vea.

### Generar imágenes sin facturas mensuales
Midjourney son unos 30€/mes. DALL-E por API se paga por imagen. Con **ComfyUI + FLUX** (perfil `creator`) generas tantas como quieras: miniaturas de YouTube, mockups, ilustraciones, assets para juegos, avatares. Cero límites, cero suscripción.

### Vídeo generativo (la nueva frontera)
Sora cuesta 200€/mes. Runway y Kling también. Con **Wan / HunyuanVideo / CogVideoX** locales no será calidad Sora todavía, pero **tampoco pagas por cada clip**. Y mejora cada mes.

### Transcribir cualquier cosa
Reuniones, vídeos, notas de voz, podcasts, entrevistas. **Whisper** local hace lo mismo que pagar a un servicio de transcripción — sin enviar audio confidencial a la nube, sin límite de minutos, sin coste por hora.

### Voz sintética para tus proyectos
ElevenLabs son unos 22€/mes y limita caracteres. Con **Kokoro TTS** (perfil `creator`) generas locuciones para vídeos, audiolibros, accesibilidad o tu propio asistente de voz. Sin contador. Y como expone API compatible con OpenAI, lo enchufas a cualquier cliente existente cambiando solo la URL base.

### Agentes que trabajan por ti
Lo realmente potente. Con **n8n + tu LLM local** montas workflows que:

- vigilan tu correo y resumen lo importante por la mañana,
- procesan facturas que llegan a una carpeta,
- monitorizan webs y te avisan de cambios,
- automatizan tareas repetitivas de tu negocio.

Todo eso girando 24/7 en tu máquina, sin pagar por API call.

> **El patrón:** lo que hoy pagas en 5 suscripciones distintas (ChatGPT Plus + Copilot + Midjourney + ElevenLabs + un transcriptor) se convierte en **un kit propio, una sola vez, tuyo para siempre**.

---

## El kit, por niveles de preparación

| Nivel | Perfil / Modo | Estado | Qué incluye | Para cuándo |
|-------|---------------|--------|-------------|-------------|
| Apagón básico | `basic` | Disponible | Ollama + Open WebUI | "Solo necesito chatear sin depender de nadie." |
| Modo creador | `creator` | Disponible | + Whisper + Kokoro TTS (audio) | "Quiero transcribir y generar voz local." |
| Imagen y vídeo (NVIDIA) | `image` | Disponible | + ComfyUI en Docker | "Tengo GPU NVIDIA en Linux/Windows." |
| Imagen y vídeo (Mac) | script nativo | Disponible | + ComfyUI nativo con Metal | "Estoy en Apple Silicon." |
| Búnker total | `bunker` | Disponible | + LiteLLM (proxy compatible con OpenAI) | "Mi SaaS sigue funcionando aunque desaparezca OpenAI." |

---

## Protocolo de activación — perfil `basic`

### Inventario mínimo

- Docker + Docker Compose
- 8 GB de RAM (16 GB recomendado)
- Unos 15 GB libres en el disco virtual de Docker. Sí, **el de Docker**, no el del sistema. Si vas justo: Docker Desktop -> Settings -> Resources -> Disk image size.

### Activar el generador

```bash
git clone <este-repo>
cd ai-survival-kit
cp .env.example .env
docker compose --profile basic up -d
```

Eso es todo. En 5-10 minutos (lo que tarde en descargar el modelo) tienes tu propio ChatGPT corriendo en `http://localhost:3000`.

Para ver cómo va la descarga del modelo:

```bash
docker compose logs -f model-puller
```

Cuando termine: abre [http://localhost:3000](http://localhost:3000), crea tu cuenta, y empieza a hablar con tu IA. **Tuya. En tu máquina. Sin que nadie mire.**

### Apagar y encender el generador

```bash
docker compose --profile basic down       # apagar
docker compose --profile basic up -d      # encender
```

Tus conversaciones y modelos quedan guardados en volúmenes Docker. Aunque apagues, el sótano sigue ahí.

---

## Protocolo de activación — perfil `creator`

Añade transcripción y voz al kit. Funciona en cualquier plataforma (Linux, Mac Apple Silicon, Windows) porque va en CPU sin problemas.

### Qué arranca

| Servicio | Para qué | URL | API |
|----------|----------|-----|-----|
| faster-whisper-server | Transcripción de audio | http://localhost:8001 | Compatible OpenAI (`/v1/audio/transcriptions`) |
| Kokoro TTS | Voz sintética | http://localhost:8002 | Compatible OpenAI (`/v1/audio/speech`) |

Ambas APIs son **drop-in de OpenAI**: si tu código hoy llama a `api.openai.com/v1/audio/...`, mañana solo cambias la `base_url` y sigue funcionando. Sin reescribir nada.

### Activar

```bash
docker compose --profile creator up -d
```

### Probar Whisper desde la terminal

```bash
curl -X POST http://localhost:8001/v1/audio/transcriptions \
  -F "file=@audio.mp3" \
  -F "model=Systran/faster-whisper-small"
```

### Probar Kokoro TTS

```bash
curl -X POST http://localhost:8002/v1/audio/speech \
  -H "Content-Type: application/json" \
  -d '{"model":"kokoro","voice":"af_bella","input":"Bienvenido al búnker."}' \
  --output voz.mp3
```

---

## Protocolo de activación — imagen y vídeo

Aquí el repo se bifurca según el hardware. La razón es práctica, no caprichosa:

> **ComfyUI necesita GPU para ser usable.** Y la GPU se accede de forma muy distinta según la plataforma:
> - En **Linux/Windows con NVIDIA**, Docker puede pasar la GPU al contenedor con `nvidia-container-toolkit`. Funciona perfectamente.
> - En **Mac Apple Silicon**, Docker **no** expone Metal al contenedor. Cualquier UI de difusión (ComfyUI, A1111, InvokeAI, Fooocus...) dentro de Docker iría en CPU emulada: **10-20 minutos por imagen, inviable**. La única forma de aprovechar la GPU del Mac es ejecutar Python directamente en el host, donde sí ve Metal.
>
> Por eso el kit ofrece **dos caminos** para imagen que llegan al mismo sitio: ComfyUI corriendo en `localhost:8188` y leyendo modelos de `creator-data/comfyui/models/`.

### Camino A — perfil `image` (Linux / Windows con GPU NVIDIA)

```bash
docker compose --profile image up -d
```

Abre http://localhost:8188.

### Camino B — script nativo (Mac Apple Silicon)

Un único script que vive **dentro del repo** y no toca nada del sistema. Todo se instala bajo `creator-data/comfyui-native/` (gitignored). Para limpiarlo: `./scripts/comfyui-mac.sh uninstall` o directamente `rm -rf creator-data/comfyui-native`.

```bash
./scripts/comfyui-mac.sh install     # primera vez (5-10 min)
./scripts/comfyui-mac.sh start       # arrancar (Ctrl+C para parar)
./scripts/comfyui-mac.sh update      # actualizar a la última versión
./scripts/comfyui-mac.sh uninstall   # borrar todo, modelos a salvo
```

Abre http://localhost:8188.

**Por qué esta excepción al "todo en Docker":**

- Es la única forma de aprovechar Metal en Mac. La alternativa es no tener imagen en Mac.
- Está confinada al directorio del repo: cero archivos en `/usr/local`, cero daemons, cero entradas en launchd. Solo una carpeta + un `venv` aislado.
- Comparte modelos con la versión Docker. Si mañana migras a un PC con NVIDIA, los `.safetensors` ya están en su sitio y el perfil `image` los encuentra sin tocar nada.
- Requisitos mínimos en el host: `python3` (3.10+) y `git`. Si no los tienes, el script te avisa y no instala nada por su cuenta.

### Avisos comunes a ambos caminos

- **Los modelos no se descargan solos.** Pesan demasiado (FLUX son 12-24 GB) y las licencias varían. Sigue [docs/creator-models.md](docs/creator-models.md) y colócalos en `creator-data/comfyui/models/`.
- **Vídeo (CogVideoX, HunyuanVideo, Wan) necesita VRAM seria** (12 GB mínimo, 24 GB recomendado) y los tiempos son largos (minutos por clip de 2-5 segundos). En Mac es viable solo en M3 Max / M4 Pro+ con 32+ GB de RAM unificada.

### Cuidado con los workflows "API" de Comfy.org

Las versiones recientes de ComfyUI traen una galería de templates que **mezcla dos cosas muy distintas**:

- **Workflows locales** — usan tu GPU/Metal y tus modelos descargados. Gratis y offline. **Esto es lo que queremos.**
- **Workflows "API"** — son nodos que llaman a APIs de pago (Comfy.org, Runway, Kling, Luma, Ideogram...). **Necesitan créditos y conexión.** Esto **rompe la promesa del survival kit**.

Si ves cualquiera de estos nombres en el workflow o en los nodos, **es de pago**: `Seedance`, `Kling`, `Veo`, `Runway`, `Flux Pro API`, `Recraft`, `Ideogram`, `Luma`, `OpenAI`, o cualquier nodo con "API" en el nombre.

**Cómo saber si un workflow es local:** los nodos típicos son `Load Checkpoint`, `Load Diffusion Model`, `KSampler`, `CLIP Text Encode`, `VAE Decode`. Si lo que ves es eso, estás en casa.

**Sobre la cuenta de Comfy.org:** la puedes ignorar. Solo sirve para esos workflows de pago. Para todo lo local **no necesitas estar logueado**.

Templates locales recomendados para empezar (`Workflow -> Browse Templates`):

- `Image Generation -> SDXL Simple` — el "hola mundo". Funciona con `sd_xl_base_1.0.safetensors`.
- `Image Generation -> Flux Schnell` — calidad muy superior, requiere los archivos de FLUX (ver [docs/creator-models.md](docs/creator-models.md)).
- Cualquiera que **no** lleve la palabra "API" en el nombre.

---

## Protocolo de activación — perfil `bunker`

Esto es **la pieza más valiosa del kit** si tienes una app o SaaS que ya usa la API de OpenAI.

### Qué hace LiteLLM

Arranca un proxy en `http://localhost:4000` que **habla exactamente la misma API que OpenAI**, pero por dentro enruta a tus servicios locales:

| Cuando tu app llama a... | LiteLLM lo enruta a... |
|--------------------------|------------------------|
| `POST /v1/chat/completions` con modelo `gpt-4o` | Ollama con `qwen2.5:7b` |
| `POST /v1/chat/completions` con modelo `gpt-4o-mini` | Ollama con `qwen2.5:3b` |
| `POST /v1/audio/transcriptions` con `whisper-1` | faster-whisper-server |
| `POST /v1/audio/speech` con `tts-1` | Kokoro |

El mapeo se configura en `litellm/config.yaml`. Cambia ahí los modelos a los que tengas descargados en Ollama.

### Activar

```bash
docker compose --profile bunker up -d
```

Esto arranca Ollama + Open WebUI + Whisper + Kokoro + LiteLLM, todo junto.

### Probarlo desde tu código

Si tu app hoy hace esto contra OpenAI:

```python
from openai import OpenAI

client = OpenAI(api_key="sk-...")
resp = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Hola"}],
)
```

Solo cambia **dos líneas**:

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:4000/v1",   # <— tu búnker
    api_key="not-needed",                  # <— LiteLLM no exige por defecto
)
resp = client.chat.completions.create(
    model="gpt-4o",                        # <— el mismo nombre de siempre
    messages=[{"role": "user", "content": "Hola"}],
)
```

Tu código sigue creyendo que habla con OpenAI. Tu factura, no.

### Probar desde la terminal

```bash
curl http://localhost:4000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o-mini",
    "messages": [{"role": "user", "content": "¿Quién manda en mi infraestructura?"}]
  }'
```

### Por qué esto importa tanto

Todo el resto del kit te da **autonomía técnica**. LiteLLM te da **autonomía operativa**: tus apps en producción siguen funcionando aunque OpenAI suba precios, cambie términos, discontinue un modelo o tu cuenta desaparezca de un día para otro. **Sin tocar código.**

---

## Elegir tu ración de modelo

Edita `DEFAULT_MODEL` en `.env` o descarga más modelos desde Open WebUI (`Settings -> Models`).

| Tu hardware | Modelo | Tamaño | Notas |
|-------------|--------|--------|-------|
| CPU / 8 GB RAM | `qwen2.5:3b` | ~2 GB | El kit de emergencia. Funciona en casi cualquier sitio. |
| 16 GB RAM o GPU 6 GB | `qwen2.5:7b` | ~4.5 GB | El sweet spot. Tu ración diaria recomendada. |
| GPU 12 GB+ | `qwen2.5:14b` | ~9 GB | Si tienes hardware decente, no lo desaproveches. |
| Coding | `qwen2.5-coder:7b` | ~4.5 GB | Para cuando se caiga Copilot. |
| Multilingüe ligero | `llama3.2:3b` | ~2 GB | Alternativa de Meta. |

### Whisper (perfil `creator`)

Modelo de transcripción. Se ajusta en `.env` con `WHISPER_MODEL`. Cuanto más grande, mejor transcripción pero más lento.

| Modelo | Tamaño | Velocidad CPU | Cuándo usarlo |
|--------|--------|---------------|---------------|
| `Systran/faster-whisper-tiny` | ~75 MB | Muy rápido | Notas de voz cortas, calidad baja |
| `Systran/faster-whisper-base` | ~145 MB | Rápido | Uso casual |
| `Systran/faster-whisper-small` | ~480 MB | Razonable | **Por defecto. Buen equilibrio.** |
| `Systran/faster-whisper-medium` | ~1.5 GB | Lento en CPU | Reuniones, contenido importante |
| `Systran/faster-whisper-large-v3` | ~3 GB | Solo viable en GPU | Máxima calidad, multilingüe |

---

## ¿Cuánto disco necesito?

| Escenario | Disco recomendado en Docker |
|-----------|---------------------------|
| Solo perfil `basic` con 1 modelo | 15 GB mínimo |
| `basic` cómodo (varios modelos) | 25-30 GB |
| `basic` + `creator` | 60-70 GB |
| `bunker` completo | 100-120 GB |

Docker Desktop solo ocupa el espacio que usa realmente. Sube el límite a 80-100 GB y olvídate.

---

## Notas por plataforma

### macOS (Apple Silicon)
Docker **no** expone la GPU Metal a los contenedores. Dentro de Docker funciona en CPU (lento pero funcional). Para velocidad real, instala **Ollama nativo** desde [ollama.com/download](https://ollama.com/download) y comenta el servicio `ollama` del compose. Open WebUI seguirá funcionando si pones `OLLAMA_BASE_URL=http://host.docker.internal:11434`.

### Linux con GPU NVIDIA
Instala [`nvidia-container-toolkit`](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html) y descomenta el bloque `deploy:` en `docker-compose.yml`. Bienvenido al búnker rápido.

### Windows
WSL2 + Docker Desktop. Para GPU NVIDIA, sigue [esta guía](https://docs.nvidia.com/cuda/wsl-user-guide/).

---

## Estructura del repo

```
ai-survival-kit/
├── docker-compose.yml      # Todos los servicios, organizados por profiles
├── .env.example            # Tu configuración (cópialo a .env)
├── litellm/
│   └── config.yaml         # Mapeo modelos OpenAI -> backends locales
├── docs/
│   └── creator-models.md   # Guía de descarga de modelos de imagen/vídeo/voz
├── scripts/
│   └── comfyui-mac.sh      # Instalador de ComfyUI nativo para Apple Silicon
├── creator-data/           # (gitignored) modelos, instalación nativa y outputs
└── README.md               # Estás aquí
```

Próximamente: `scripts/`, `model-packs/`, perfil `bunker`.

---

## Roadmap de supervivencia

- [x] Perfil `basic` — Ollama + Open WebUI
- [x] Perfil `creator` — faster-whisper-server + Kokoro TTS
- [x] Perfil `image` (NVIDIA) + script `comfyui-mac.sh` (Apple Silicon) — generación de imagen y vídeo
- [x] Perfil `bunker` — LiteLLM (proxy compatible con OpenAI)
- [ ] Extensiones del búnker: RAG dedicado (AnythingLLM) + n8n para agentes 24/7
- [ ] Script `install-model-pack` para descargar packs de modelos por caso de uso
- [ ] Benchmarks por tipo de hardware ("¿qué corre mi portátil?")
- [ ] Backups automáticos de conversaciones y configuración
- [ ] Modo `low-power` para mini PCs y Raspberry Pi

---

## Troubleshooting rápido

**"no space left on device" al hacer `docker compose up`**
No es tu disco del sistema, es el de Docker. Docker Desktop -> Settings -> Resources -> Disk image size. Súbelo. O ejecuta `docker system prune -a` para limpiar.

**Open WebUI no encuentra modelos**
Espera a que `model-puller` termine: `docker compose logs -f model-puller`.

**Va muy lento en Mac**
Lee la sección de macOS arriba. Instala Ollama nativo.

**ComfyUI tarda eternamente en generar una imagen**
Estás en CPU. Es lo esperado: en CPU son varios minutos por imagen, en GPU son segundos. Soluciones: o instalas ComfyUI nativo (en Mac usa Metal), o activas el bloque `deploy:` de NVIDIA en `docker-compose.yml` si tienes GPU.

**ComfyUI dice "model not found"**
No has descargado modelos. Revisa [docs/creator-models.md](docs/creator-models.md) y colócalos en `creator-data/comfyui/models/` con la estructura que indica.

**ComfyUI me pide pagar / pide créditos al ejecutar un workflow**
Has caído en un workflow "API" que llama a un servicio de pago (Seedance, Kling, Veo, Flux Pro, etc.). Eso no es local. Cierra ese template y abre uno que diga `SDXL Simple` o `Flux Schnell` sin la palabra "API". Lee la sección "Cuidado con los workflows API de Comfy.org" más arriba.

**La primera petición a Whisper tarda mucho**
Está descargando el modelo (entre 75 MB y 3 GB según el que hayas elegido). Las siguientes peticiones serán instantáneas. Sigue el progreso con `docker compose logs -f whisper`.

**Kokoro TTS no encuentra la voz**
Lista las voces disponibles con `curl http://localhost:8002/v1/audio/voices`. Usa una de esa lista (ej. `af_bella`, `am_adam`, `bf_emma`).

---

## Licencia

MIT. Cógelo, fórkalo, móntalo en tu búnker. Lo único que pedimos: no te cases con ninguna IA propietaria sin tener este kit preparado primero.

---

```
        ╔══════════════════════════════════════╗
        ║  "En el búnker nadie te ratelimita"  ║
        ╚══════════════════════════════════════╝
```

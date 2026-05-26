# Modelos para el perfil `creator`

Los modelos de imagen y vídeo pesan mucho (entre 2 y 25 GB cada uno) y tienen licencias muy distintas, así que **no se descargan automáticamente**. Aquí tienes los enlaces y dónde dejar cada archivo.

La raíz de modelos de ComfyUI dentro del repo es:

```
creator-data/comfyui/models/
```

Esa carpeta se monta directamente en el contenedor. Reinicia ComfyUI (`docker compose restart comfyui`) o usa el botón "Refresh" del interfaz tras añadir modelos nuevos.

---

## Generadores de imagen recomendados

### FLUX.1-schnell (rápido, licencia Apache 2.0)

Lo mejor que hay ahora mismo en local sin pelearte con licencias raras. Calidad muy alta, 4 pasos por imagen.

- **Modelo principal:** [flux1-schnell.safetensors](https://huggingface.co/black-forest-labs/FLUX.1-schnell/blob/main/flux1-schnell.safetensors) (~24 GB)
  Versión FP8 más ligera: [flux1-schnell-fp8.safetensors](https://huggingface.co/Comfy-Org/flux1-schnell/blob/main/flux1-schnell-fp8.safetensors) (~12 GB)
  -> `creator-data/comfyui/models/unet/`

- **VAE:** [ae.safetensors](https://huggingface.co/black-forest-labs/FLUX.1-schnell/blob/main/ae.safetensors) (~335 MB)
  -> `creator-data/comfyui/models/vae/`

- **Text encoders:** [clip_l.safetensors](https://huggingface.co/comfyanonymous/flux_text_encoders/blob/main/clip_l.safetensors) y [t5xxl_fp8_e4m3fn.safetensors](https://huggingface.co/comfyanonymous/flux_text_encoders/blob/main/t5xxl_fp8_e4m3fn.safetensors)
  -> `creator-data/comfyui/models/clip/`

### SDXL base 1.0 (más ligero, ecosistema enorme)

Si tienes menos VRAM o quieres usar miles de LoRAs/checkpoints que ya existen.

- **Modelo:** [sd_xl_base_1.0.safetensors](https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/blob/main/sd_xl_base_1.0.safetensors) (~6.5 GB)
  -> `creator-data/comfyui/models/checkpoints/`

### Checkpoints comunitarios

Para fotorrealismo, estilo anime, etc. Búscalos en [Civitai](https://civitai.com/) y déjalos en `checkpoints/`.

Recomendados:
- **Juggernaut XL** — fotorrealismo
- **RealVisXL** — fotorrealismo
- **Pony Diffusion / Illustrious** — ilustración / anime

---

## Generadores de vídeo

Avisos sinceros: vídeo local consume mucha VRAM (mínimo 12 GB, ideal 24 GB) y los tiempos son largos (minutos por clip de 2-5 segundos). Aún así no pagas por clip.

### CogVideoX-5B
- [Repo en Hugging Face](https://huggingface.co/THUDM/CogVideoX-5b)
- Necesita el [custom node de Kijai](https://github.com/kijai/ComfyUI-CogVideoXWrapper)

### HunyuanVideo (Tencent)
- [Repo](https://huggingface.co/tencent/HunyuanVideo)
- Calidad superior, exige bastante hardware

### Wan 2.x (Alibaba)
- Aparecen nuevas versiones constantemente. Busca el último en Hugging Face.

Instalación de custom nodes para vídeo: dentro de ComfyUI usa el ComfyUI Manager (incluido en la imagen `yanwk/comfyui-boot`).

---

## Voces para Kokoro TTS

Las voces vienen incluidas en la imagen. Para listarlas:

```bash
curl http://localhost:8002/v1/audio/voices
```

Para usarla desde código (ejemplo Python con el cliente de OpenAI):

```python
from openai import OpenAI

client = OpenAI(base_url="http://localhost:8002/v1", api_key="not-needed")

resp = client.audio.speech.create(
    model="kokoro",
    voice="af_bella",            # u otra de la lista
    input="Bienvenido al búnker."
)
resp.stream_to_file("output.mp3")
```

---

## Modelos de Whisper

Se descargan automáticamente la primera vez. Cambia `WHISPER_MODEL` en `.env` para usar uno distinto. Quedan cacheados en el volumen `whisper_data`.

Uso desde código:

```python
from openai import OpenAI

client = OpenAI(base_url="http://localhost:8001/v1", api_key="not-needed")

with open("reunion.mp3", "rb") as f:
    transcript = client.audio.transcriptions.create(
        model="Systran/faster-whisper-small",
        file=f,
    )
print(transcript.text)
```

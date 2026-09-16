# Orvexa Agentic Media

Orvexa is an experimental AI systems project for exploring **agentic
media generation**, model orchestration, evaluation, and scalable AI
system design.

The project initially focuses on comparing multiple generative video
models behind a common capability-oriented interface.

## Development Environment

Recommended environment:

-   Windows + WSL2
-   Cursor connected to WSL
-   Python managed by `uv`
-   Project files stored inside the WSL filesystem
-   Model weights stored locally and excluded from Git

Example project location:

``` text
/home/devuser/projects/orvexa-agentic-media
```

## Python Environment with uv

Initialize the project and select a Python version:

``` bash
uv init
uv python pin 3.12
```

Install dependencies:

``` bash
uv add huggingface-hub pyyaml
uv add --dev pytest ruff
```

Run Python commands through the project environment:

``` bash
uv run python <script>
```

`uv` manages the project through:

``` text
pyproject.toml     dependency specification
uv.lock            reproducible dependency resolution
.python-version    preferred Python version
.venv/             local virtual environment
```

A virtual environment normally does not need to be created manually.
Commands such as `uv add` and `uv sync` will create and maintain `.venv`
when necessary.

## Model Configuration

Model dependencies are declared in:

``` text
config/models.yaml
```

Models are organized by **capability**, then by **provider/model
implementation**.

Example:

``` yaml
models:
  text_to_video:
    wan:
      repo_id: "Wan-AI/Wan2.1-T2V-1.3B"
      revision: "main"
      local_dir: "models/text_to_video/wan"

    ltx:
      repo_id: "Lightricks/LTX-Video"
      revision: "main"
      local_dir: "models/text_to_video/ltx"

  image_to_video:
    stable_video_diffusion:
      repo_id: "stabilityai/stable-video-diffusion-img2vid-xt"
      revision: "main"
      local_dir: "models/image_to_video/svd"
```

Conceptually:

``` text
Video Generation
├── Text-to-Video
│   ├── Wan
│   └── LTX
└── Image-to-Video
    ├── LTX
    └── Stable Video Diffusion
```

This separates the **capability contract** from the concrete model
implementation. Later, Orvexa can place different model adapters behind
common interfaces such as `TextToVideo` and `ImageToVideo`.

## Downloading Models

Model provisioning is handled by:

``` text
scripts/download_models.py
```

The downloader uses Python's standard `argparse` library and accepts two
positional arguments:

``` text
<capability> <provider>
```

General command:

``` bash
uv run python scripts/download_models.py <capability> <provider>
```

Download Wan text-to-video:

``` bash
uv run python scripts/download_models.py --capability text_to_video --provider wan_native
```
``` bash
uv run python scripts/download_models.py --capability text_to_video --provider wan_diffusers
```
Download LTX text-to-video:

``` bash
uv run python scripts/download_models.py --capability text_to_video --provider ltx
```

Download Stable Video Diffusion:

``` bash
uv run python scripts/download_models.py --capability image_to_video --provider stable_video_diffusion
```

Show CLI help:

``` bash
uv run python scripts/download_models.py --help
```

## Model Storage

Downloaded model weights are runtime assets and must not be committed to
Git.

Recommended `.gitignore` entries:

``` gitignore
models/*
!models/.gitkeep

*.safetensors
*.ckpt
*.pt
*.pth
*.bin
*.gguf
```

The repository stores **how to reproduce the model environment**, not
the model weights themselves:

``` text
config/models.yaml
        +
scripts/download_models.py
        ↓
model provisioning
        ↓
models/
```

## Current Design Principle

Orvexa treats a model as an implementation of a capability rather than
as the system architecture itself.

The intended evolution is:

``` text
Capability
    ↓
Port / Interface
    ↓
Provider Adapter
    ↓
Concrete Model
```

For example:

``` text
TextToVideo
├── WanAdapter
└── LTXAdapter

ImageToVideo
├── LTXAdapter
└── SVDAdapter
```

This structure will later allow the same Orvexa workflow to switch
models, benchmark providers, evaluate outputs, and route generation
requests without coupling the application layer to one specific model.

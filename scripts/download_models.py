from pathlib import Path
import argparse

import yaml

from huggingface_hub import snapshot_download
from huggingface_hub.utils import enable_progress_bars

ROOT = Path(__file__).resolve().parents[1]
CONFIG_PATH = ROOT / "config"/ "models.yaml"

def load_config() -> dict:
    with CONFIG_PATH.open("r", encoding="utf-8") as f:
        return yaml.safe_load(f)

def download_model(capability:str,provider:str, config:dict)->None:
    repo_id = config["repo_id"]
    revision = config.get("revision", "main")
    local_dir = ROOT/ config["local_dir"]

    print(f"Downloading {capability} / {provider} from {repo_id} revision {revision} to {local_dir}")
    print("This may take a while...")
    enable_progress_bars()
    try:
        snapshot_download(
            repo_id= repo_id,
            revision=revision,  
            local_dir=local_dir,
        )
        print(f"Downloaded {capability} / {provider} to {local_dir}")
    except Exception as e:
        print(f"Error downloading {capability} / {provider}: {e}")

def parse_args()->argparse.Namespace:
    parser = argparse.ArgumentParser(description="Download models configured for Orvexa")
    parser.add_argument("--capability", type=str, required=True, help="The capability of the model,e.g. text_to_video, image_to_video")
    parser.add_argument("--provider", type=str, required=True, help="The provider of the model, e.g. wan, ltx, stable_video_diffusion")
    return parser.parse_args()

def main()->None:
    args = parse_args()
    config = load_config()
    capability = args.capability
    provider = args.provider

    if capability not in config["models"]:
        print(f"Capability {capability} not found in config")
        return

    if provider not in config["models"][capability]:
        print(f"Provider {provider} not found in config for capability {capability}")
        return

    download_model(capability, provider, config["models"][capability][provider])

if __name__ == "__main__":
    main()
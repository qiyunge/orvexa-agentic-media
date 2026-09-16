import torch
from pathlib import Path

from diffusers import WanPipeline
from diffusers.utils import export_to_video

ROOT = Path(__file__).resolve().parents[1]
MODEL_DIR = ROOT / "models" / "text_to_video" / "wan_diffusers"

OUTPUT_DIR = ROOT / "outputs"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

def main():
    print(f"CUDA available: {torch.cuda.is_available()}")
    print(f"CUDA device: {torch.cuda.get_device_name(torch.cuda.current_device())}")
    print(f"CUDA device count: {torch.cuda.device_count()}")
    print(f"CUDA device index: {torch.cuda.current_device()}")
    print(f"CUDA device memory: {torch.cuda.get_device_properties(torch.cuda.current_device()).total_memory}")
    print(f"CUDA device memory: {torch.cuda.get_device_properties(torch.cuda.current_device()).total_memory}")

    print(f"Loading model from {MODEL_DIR}")
    model = WanPipeline.from_pretrained(MODEL_DIR, torch_dtype=torch.bfloat16)
    print("Model loaded successfully")
    # 4070 Laptop has 8GB of VRAM, so we need to use a smaller batch size
    model.enable_model_cpu_offload()
    print("Model offloaded to CPU")

    prompt = (
    "A bright red ball moves quickly from the far left side "
    "of the frame to the far right side, "
    "large obvious displacement, fixed camera, "
    "completely static white background, "
    "smooth continuous motion."
)

    print(f"Generating video for prompt: {prompt}")
    video =model(
        prompt,
        height=256,
        width=448,
        num_frames=33,
        num_inference_steps=15,
        guidance_scale=5.0,
    )

    frames = video.frames[0]

    output_path = OUTPUT_DIR / "wan_diffusers_test.mp4"
    export_to_video(frames, str(output_path), fps=8)
    print(f"Video generated successfully and saved to {output_path}")

if __name__ == "__main__":
    print("Starting WAN Diffusers test...")
    main()
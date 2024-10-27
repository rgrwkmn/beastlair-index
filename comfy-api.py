#This is an example that uses the websockets api to know when a prompt execution is done
#Once the prompt execution is done it downloads the images using the /history endpoint

import websocket #NOTE: websocket-client (https://github.com/websocket-client/websocket-client)
import uuid
import json
import urllib.request
import urllib.parse
import random
from datetime import date
import time

server_address = "127.0.0.1:8188"
client_id = str(uuid.uuid4())

def queue_prompt(prompt):
    p = {"prompt": prompt, "client_id": client_id}
    data = json.dumps(p).encode('utf-8')
    req =  urllib.request.Request("http://{}/prompt".format(server_address), data=data)
    return json.loads(urllib.request.urlopen(req).read())

def get_image(filename, subfolder, folder_type):
    data = {"filename": filename, "subfolder": subfolder, "type": folder_type}
    url_values = urllib.parse.urlencode(data)
    with urllib.request.urlopen("http://{}/view?{}".format(server_address, url_values)) as response:
        return response.read()

def get_history(prompt_id):
    with urllib.request.urlopen("http://{}/history/{}".format(server_address, prompt_id)) as response:
        return json.loads(response.read())

def get_images(ws, prompt):
    prompt_id = queue_prompt(prompt)['prompt_id']
    output_images = {}
    while True:
        out = ws.recv()
        if isinstance(out, str):
            message = json.loads(out)
            # print(message)
            if message['type'] == 'executing':
                data = message['data']
                if data['node'] is None and data['prompt_id'] == prompt_id:
                    break #Execution is done
        else:
            continue #previews are binary data

    history = get_history(prompt_id)[prompt_id]
    for o in history['outputs']:
        for node_id in history['outputs']:
            node_output = history['outputs'][node_id]
            if 'images' in node_output:
                images_output = []
                for image in node_output['images']:
                    # image_data = get_image(image['filename'], image['subfolder'], image['type'])
                    images_output.append((image['filename'], image['subfolder'], image['type']))
            output_images[node_id] = images_output

    return output_images

prompt_text = """
{
  "4": {
    "inputs": {
      "ckpt_name": "RealitiesEdgeXL_5.safetensors"
    },
    "class_type": "CheckpointLoaderSimple"
  },
  "7": {
    "inputs": {
      "text": "photograph, photography, bloom, soft focus, overhead light",
      "clip": [
        "133",
        0
      ]
    },
    "class_type": "CLIPTextEncode"
  },
  "23": {
    "inputs": {
      "width": [
        "120",
        0
      ],
      "height": [
        "120",
        1
      ],
      "batch_size": [
        "120",
        3
      ]
    },
    "class_type": "EmptyLatentImage"
  },
  "45": {
    "inputs": {
      "samples": [
        "71",
        0
      ],
      "vae": [
        "74",
        2
      ]
    },
    "class_type": "VAEDecode"
  },
  "71": {
    "inputs": {
      "seed": 1068805256747025,
      "steps": 43,
      "cfg": 9.91,
      "sampler_name": "dpmpp_3m_sde_gpu",
      "scheduler": "sgm_uniform",
      "denoise": 0.42,
      "model": [
        "74",
        0
      ],
      "positive": [
        "144",
        0
      ],
      "negative": [
        "76",
        0
      ],
      "latent_image": [
        "203",
        0
      ]
    },
    "class_type": "KSampler"
  },
  "74": {
    "inputs": {
      "ckpt_name": "edgeOfRealism_eorV20Fp16BakedVAE.safetensors"
    },
    "class_type": "CheckpointLoaderSimple"
  },
  "76": {
    "inputs": {
      "text": "photograph, photography, bloom, soft focus, overhead light",
      "clip": [
        "74",
        1
      ]
    },
    "class_type": "CLIPTextEncode"
  },
  "99": {
    "inputs": {
      "filename_prefix": "%sessionInfo.text%-2023-11-28-Edge",
      "images": [
        "45",
        0
      ]
    },
    "class_type": "SaveImage"
  },
  "120": {
    "inputs": {
      "width": 1024,
      "height": 1024,
      "aspect_ratio": "9:16 portrait 768x1344",
      "swap_dimensions": "Off",
      "upscale_factor": 1,
      "batch_size": 1
    },
    "class_type": "CR SDXL Aspect Ratio"
  },
  "128": {
    "inputs": {
      "seed": 1068805256747025,
      "steps": 20,
      "cfg": 6.66,
      "sampler_name": "dpmpp_3m_sde_gpu",
      "scheduler": "karras",
      "denoise": 1,
      "model": [
        "4",
        0
      ],
      "positive": [
        "142",
        0
      ],
      "negative": [
        "7",
        0
      ],
      "latent_image": [
        "23",
        0
      ]
    },
    "class_type": "KSampler"
  },
  "132": {
    "inputs": {
      "vae_name": "sdxl_vae.safetensors"
    },
    "class_type": "VAELoader"
  },
  "133": {
    "inputs": {
      "stop_at_clip_layer": -1,
      "clip": [
        "4",
        1
      ]
    },
    "class_type": "CLIPSetLastLayer"
  },
  "142": {
    "inputs": {
      "text_l": "(death metal album cover painting by Roger Dean for the band Beast Lair's first album titled Redecorator:1.2), for the (secret of mana) video game for snes, a (grim dark dungeon lair:1.2) battlestation, a landscape vista is visible through the mouth of the cave, computer desk, ergonomic desk chair, moody lighting, computer monitors showing landscapes, mechanical keyboards with custom keycaps, black light reactive posters hung on the walls, speaker cabinet stacks, synthesizers, audio equipment, rack mount hardware, lava lamp, utility muffin research kitchen, (battlestation), intricate details, ambiguous perspective",
      "text_g": "(death metal album cover painting by Roger Dean for the band Beast Lair's first album titled Redecorator:1.2), for the (secret of mana) video game for snes, a (grim dark dungeon lair:1.2) battlestation, a landscape vista is visible through the mouth of the cave, computer desk, ergonomic desk chair, moody lighting, computer monitors showing landscapes, mechanical keyboards with custom keycaps, black light reactive posters hung on the walls, speaker cabinet stacks, synthesizers, audio equipment, rack mount hardware, lava lamp, utility muffin research kitchen, (battlestation), intricate details, ambiguous perspective",
      "token_normalization": "none",
      "weight_interpretation": "A1111",
      "balance": 0.2,
      "clip": [
        "133",
        0
      ]
    },
    "class_type": "BNK_CLIPTextEncodeSDXLAdvanced"
  },
  "144": {
    "inputs": {
      "text": "(death metal album cover painting by Roger Dean for the band Beast Lair's first album titled Redecorator:1.2), for the (secret of mana) video game for snes, a (grim dark dungeon lair:1.2) battlestation, a landscape vista is visible through the mouth of the cave, computer desk, ergonomic desk chair, moody lighting, computer monitors showing landscapes, mechanical keyboards with custom keycaps, black light reactive posters hung on the walls, speaker cabinet stacks, synthesizers, audio equipment, rack mount hardware, lava lamp, utility muffin research kitchen, (battlestation), intricate details, ambiguous perspective",
      "token_normalization": "none",
      "weight_interpretation": "A1111",
      "clip": [
        "74",
        1
      ]
    },
    "class_type": "BNK_CLIPTextEncodeAdvanced"
  },
  "146": {
    "inputs": {
      "upscale_method": "bicubic",
      "scale_by": 1.5,
      "samples": [
        "128",
        0
      ]
    },
    "class_type": "LatentUpscaleBy"
  },
  "198": {
    "inputs": {
      "seed": 1068805256747025,
      "steps": 25,
      "cfg": 12.97,
      "sampler_name": "dpmpp_3m_sde_gpu",
      "scheduler": "karras",
      "denoise": 0.42,
      "model": [
        "4",
        0
      ],
      "positive": [
        "142",
        0
      ],
      "negative": [
        "7",
        0
      ],
      "latent_image": [
        "146",
        0
      ]
    },
    "class_type": "KSampler"
  },
  "203": {
    "inputs": {
      "tile_mode": "None",
      "tile_size": 512,
      "samples": [
        "198",
        0
      ],
      "input_vae": [
        "132",
        0
      ],
      "output_vae": [
        "74",
        2
      ]
    },
    "class_type": "ReencodeLatent"
  }
}
"""

prompt = json.loads(prompt_text)
seed = int(random.random() * int(0xffffffffffffffff));
prompt["71"]["inputs"]["seed"] = seed;
prompt["128"]["inputs"]["seed"] = seed;
prompt["198"]["inputs"]["seed"] = seed;
# prompt["71"]["inputs"]["steps"] = 1;
# prompt["128"]["inputs"]["steps"] = 1;
# prompt["198"]["inputs"]["steps"] = 1;
prompt["99"]["inputs"]["filename_prefix"] = "DAILY/BeastLair-Daily-%s" %(date.today())

ws = websocket.WebSocket()
ws.connect("ws://{}/ws?clientId={}".format(server_address, client_id))
image = get_images(ws, prompt)['99'][0]

# print(image)
print(image[0])

#Commented out code to display the output images:

# for node_id in images:
#     for image_data in images[node_id]:
#         from PIL import Image
#         import io
#         image = Image.open(io.BytesIO(image_data))
#         image.show()
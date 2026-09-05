// Pinned upstream metadata checked 2026-09-05. Model artifacts are downloaded only on request.
// Sources and exact size accounting are documented in README.md.
export const models = [
  {
    "id": "SmolLM2-360M-Instruct-q4f16_1-MLC",
    "name": "SmolLM2 · 360M",
    "description": "Experimental, small English role-play model. Replies may be repetitive or inaccurate. About 0.4 GiB GPU memory plus browser overhead.",
    "memoryGiB": 0.4,
    "vramEstimateMB": 376.06,
    "license": "apache-2.0",
    "licenseUrl": "https://www.apache.org/licenses/LICENSE-2.0",
    "sourceUrl": "https://huggingface.co/mlc-ai/SmolLM2-360M-Instruct-q4f16_1-MLC",
    "revision": "3a622fd89e0216e8bb10c410c007c786baa8a033",
    "model": "https://huggingface.co/mlc-ai/SmolLM2-360M-Instruct-q4f16_1-MLC/resolve/3a622fd89e0216e8bb10c410c007c786baa8a033/",
    "model_lib": "https://raw.githubusercontent.com/mlc-ai/binary-mlc-llm-libs/025bcaf3780fa8254f5e5efd3bfea0a5397248f4/web-llm-models/v0_2_84/base/SmolLM2-360M-Instruct-q4f16_1_cs1k-webgpu.wasm",
    "required_features": [
      "shader-f16"
    ],
    "context_window_size": 4096,
    "artifacts": [
      {
        "path": "mlc-chat-config.json",
        "url": "https://huggingface.co/mlc-ai/SmolLM2-360M-Instruct-q4f16_1-MLC/resolve/3a622fd89e0216e8bb10c410c007c786baa8a033/mlc-chat-config.json",
        "scope": "webllm/config",
        "bytes": 2021,
        "hash": "cf7206379d83793b22ba149cdce7ff4d8ce09f15",
        "hashAlgorithm": "git-sha1"
      },
      {
        "path": "params_shard_0.bin",
        "url": "https://huggingface.co/mlc-ai/SmolLM2-360M-Instruct-q4f16_1-MLC/resolve/3a622fd89e0216e8bb10c410c007c786baa8a033/params_shard_0.bin",
        "scope": "webllm/model",
        "bytes": 33459840,
        "hash": "5d5807a95573ed1d72e8c7f2bac2911ba1ad78bb486ab9745693eb51e8b7616c",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_1.bin",
        "url": "https://huggingface.co/mlc-ai/SmolLM2-360M-Instruct-q4f16_1-MLC/resolve/3a622fd89e0216e8bb10c410c007c786baa8a033/params_shard_1.bin",
        "scope": "webllm/model",
        "bytes": 33200640,
        "hash": "7f6901def1d79db3c3eabca3e271ce7af131d3bec599971b98ad66f3cdbc3729",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_2.bin",
        "url": "https://huggingface.co/mlc-ai/SmolLM2-360M-Instruct-q4f16_1-MLC/resolve/3a622fd89e0216e8bb10c410c007c786baa8a033/params_shard_2.bin",
        "scope": "webllm/model",
        "bytes": 33200640,
        "hash": "bb2d45b7b35602e0667575de94f750dd1ec5cd5d01a840c2f2fb9bdc553fc66a",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_3.bin",
        "url": "https://huggingface.co/mlc-ai/SmolLM2-360M-Instruct-q4f16_1-MLC/resolve/3a622fd89e0216e8bb10c410c007c786baa8a033/params_shard_3.bin",
        "scope": "webllm/model",
        "bytes": 33200640,
        "hash": "0f5c419205d2d03508dbd10f937c1508902ae4ea5330a6493b3e2e7ef0df7ed0",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_4.bin",
        "url": "https://huggingface.co/mlc-ai/SmolLM2-360M-Instruct-q4f16_1-MLC/resolve/3a622fd89e0216e8bb10c410c007c786baa8a033/params_shard_4.bin",
        "scope": "webllm/model",
        "bytes": 33200640,
        "hash": "959bd10c37b9634a077e636be15e59059bea6a9a152de2e7bab81d248d0644e6",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_5.bin",
        "url": "https://huggingface.co/mlc-ai/SmolLM2-360M-Instruct-q4f16_1-MLC/resolve/3a622fd89e0216e8bb10c410c007c786baa8a033/params_shard_5.bin",
        "scope": "webllm/model",
        "bytes": 33200640,
        "hash": "99c3b1c9ef35f322013e07c607ae9c271e5895138e347a7e60acbbe1645407e8",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_6.bin",
        "url": "https://huggingface.co/mlc-ai/SmolLM2-360M-Instruct-q4f16_1-MLC/resolve/3a622fd89e0216e8bb10c410c007c786baa8a033/params_shard_6.bin",
        "scope": "webllm/model",
        "bytes": 4151040,
        "hash": "09b74f2ad1f35fcacc6567b6b6b0fc4a69dd6191dd94fad413a252096693c8c2",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "tensor-cache.json",
        "url": "https://huggingface.co/mlc-ai/SmolLM2-360M-Instruct-q4f16_1-MLC/resolve/3a622fd89e0216e8bb10c410c007c786baa8a033/tensor-cache.json",
        "scope": "webllm/model",
        "bytes": 124230,
        "hash": "7b6cf40ab27adaeb2cc70e7586aa784abfe2b972",
        "hashAlgorithm": "git-sha1"
      },
      {
        "path": "tokenizer.json",
        "url": "https://huggingface.co/mlc-ai/SmolLM2-360M-Instruct-q4f16_1-MLC/resolve/3a622fd89e0216e8bb10c410c007c786baa8a033/tokenizer.json",
        "scope": "webllm/model",
        "bytes": 2104556,
        "hash": "f922b1797f0c88e71addc8393787831f2477a4bd",
        "hashAlgorithm": "git-sha1"
      },
      {
        "path": "SmolLM2-360M-Instruct-q4f16_1_cs1k-webgpu.wasm",
        "url": "https://raw.githubusercontent.com/mlc-ai/binary-mlc-llm-libs/025bcaf3780fa8254f5e5efd3bfea0a5397248f4/web-llm-models/v0_2_84/base/SmolLM2-360M-Instruct-q4f16_1_cs1k-webgpu.wasm",
        "scope": "webllm/wasm",
        "bytes": 5708562,
        "hash": "cc20176f611d779985d4e654a141449ee66f31fe",
        "hashAlgorithm": "git-sha1"
      }
    ],
    "downloadBytes": 211553449
  },
  {
    "id": "gemma-2-2b-it-q4f16_1-MLC",
    "name": "Gemma 2 · 2B",
    "description": "Experimental, larger English role-play model. About 1.9 GiB GPU memory plus browser overhead.",
    "memoryGiB": 1.9,
    "vramEstimateMB": 1895.3,
    "license": "Gemma Terms of Use",
    "licenseUrl": "https://ai.google.dev/gemma/terms",
    "sourceUrl": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC",
    "revision": "de9cc76f0d4b3a49a0f718df424944054bf1eec1",
    "model": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/",
    "model_lib": "https://raw.githubusercontent.com/mlc-ai/binary-mlc-llm-libs/025bcaf3780fa8254f5e5efd3bfea0a5397248f4/web-llm-models/v0_2_84/base/gemma-2-2b-it-q4f16_1_cs1k-webgpu.wasm",
    "required_features": [
      "shader-f16"
    ],
    "context_window_size": 4096,
    "artifacts": [
      {
        "path": "mlc-chat-config.json",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/mlc-chat-config.json",
        "scope": "webllm/config",
        "bytes": 2063,
        "hash": "3c01f33669d8fb970fef93442342dcb07e4838dd",
        "hashAlgorithm": "git-sha1"
      },
      {
        "path": "params_shard_0.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_0.bin",
        "scope": "webllm/model",
        "bytes": 294912000,
        "hash": "358c68eddbe3dc7337dc40345f5d19bfee59c01df8f3f5a1f87667cadc91c954",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_1.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_1.bin",
        "scope": "webllm/model",
        "bytes": 36864000,
        "hash": "95fca2590ce5e017ac016a3f78384ce9207e6e385ab3822d3aa0daf480e5dcf9",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_10.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_10.bin",
        "scope": "webllm/model",
        "bytes": 33214464,
        "hash": "f9375a12c9f781b05a1466519d729ab077b9a2fd25d154c4cee9f264f4496e1b",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_11.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_11.bin",
        "scope": "webllm/model",
        "bytes": 33177600,
        "hash": "cff35d830761e27973c72c192f7534fbc101dd4dcfa2f38095089eeb79379a0b",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_12.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_12.bin",
        "scope": "webllm/model",
        "bytes": 21233664,
        "hash": "ac48aaebc2311fa443b5354ce4b52d5bcc593fc1ab2407bb79adf0775422351f",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_13.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_13.bin",
        "scope": "webllm/model",
        "bytes": 33214464,
        "hash": "43fe75793fcb179c5fdeefc6cbb9c4a767b4dbd64029ef91cd7e3edd7981d867",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_14.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_14.bin",
        "scope": "webllm/model",
        "bytes": 33177600,
        "hash": "26129ca3c912dbb7d89c645c478697f701d8324a4ba35fb7d932e904540dac85",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_15.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_15.bin",
        "scope": "webllm/model",
        "bytes": 21233664,
        "hash": "cd2da03858d92732e7745bd934e9b2b16d1353ecb1720db11d361e156207557d",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_16.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_16.bin",
        "scope": "webllm/model",
        "bytes": 33214464,
        "hash": "7cce03d992765908a03dc4044c412439714360d3fb8c19c9ad43296c24bc3657",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_17.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_17.bin",
        "scope": "webllm/model",
        "bytes": 33177600,
        "hash": "c76e8b19695fa67047df0ae09434a9a44ce62f76358382ac0a08815ea2e5d8e5",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_18.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_18.bin",
        "scope": "webllm/model",
        "bytes": 21233664,
        "hash": "371b82f9aeeba939874d600730ce6482b282577549471f57ebbfa0770d12609c",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_19.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_19.bin",
        "scope": "webllm/model",
        "bytes": 33214464,
        "hash": "6b16eb9e81014c66daab3a59204f40de84f6c62581467ed72d33b70a23e940ed",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_2.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_2.bin",
        "scope": "webllm/model",
        "bytes": 33182208,
        "hash": "5714f4f325b73e2675d8d95ad178449774c7b36d38bdbe8edd34d83622ebb4ba",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_20.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_20.bin",
        "scope": "webllm/model",
        "bytes": 33177600,
        "hash": "f6ae673641b9dcc15283031db590e99be3c800b5ee75c9d3bda3fcd0ae7af025",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_21.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_21.bin",
        "scope": "webllm/model",
        "bytes": 21233664,
        "hash": "de061dae0b37f913db432c8c2b275da051f5ef418a5134e453535ff80a5303b2",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_22.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_22.bin",
        "scope": "webllm/model",
        "bytes": 33214464,
        "hash": "f0c532d8c2a33aace7dc619046c8d95cd5166dff2d8ae6fff97ced5342583dab",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_23.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_23.bin",
        "scope": "webllm/model",
        "bytes": 33177600,
        "hash": "3398e26efbb209c88bc29023e658c0a76d9e1446d834324d8345488781d8973b",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_24.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_24.bin",
        "scope": "webllm/model",
        "bytes": 21233664,
        "hash": "dbe9988abeaf4b074fcda4ffa50ce798c55a6a5d56a5f95c632dacf9affe0da3",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_25.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_25.bin",
        "scope": "webllm/model",
        "bytes": 33214464,
        "hash": "6bc144f520e1c3ae1d657b4a988bb2b3d11100783b92230100b128d3087783ed",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_26.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_26.bin",
        "scope": "webllm/model",
        "bytes": 33177600,
        "hash": "10667e8ce89945dd6d1f19bbe6baddf11badf2b1bd1e1a92e1323dc31cc64713",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_27.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_27.bin",
        "scope": "webllm/model",
        "bytes": 31864320,
        "hash": "16c8a687e7fe31bf75c9571d3970c60bba0be18029ff8d69e5ba72abc0e4def3",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_28.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_28.bin",
        "scope": "webllm/model",
        "bytes": 21233664,
        "hash": "d7b0c361362c1f9e7b423307be27120c71009379b8c6539f14b5a7ca3500deb8",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_29.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_29.bin",
        "scope": "webllm/model",
        "bytes": 33200640,
        "hash": "88ee878f45f477aabc48a40072c77a5572462ac68fac1e2334596148702fee40",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_3.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_3.bin",
        "scope": "webllm/model",
        "bytes": 21233664,
        "hash": "9076383afaf6c3896b193b220167008bbea360b8862e156b9573d669d4869627",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_30.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_30.bin",
        "scope": "webllm/model",
        "bytes": 33177600,
        "hash": "e03a96a5ffe05ae97f3f6adaa88b8ccdf9ac1b1f850c0d9fab27ce57380a4f9c",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_31.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_31.bin",
        "scope": "webllm/model",
        "bytes": 21233664,
        "hash": "b0bb5f16555ffd96d5a1413056090dbda5a0c173b994faaee53bf958b4407cb0",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_32.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_32.bin",
        "scope": "webllm/model",
        "bytes": 33214464,
        "hash": "ab31b5a3d90c99e03572a3a10b3326e50bff719dd5be72e3bae90943b34bd0a4",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_33.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_33.bin",
        "scope": "webllm/model",
        "bytes": 33177600,
        "hash": "51d2d26a825144db090960d2c1d15c38e84e8d62f34b9229427d9b506bb38fba",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_34.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_34.bin",
        "scope": "webllm/model",
        "bytes": 21233664,
        "hash": "96a4049e9b69bc3177dd1c87a8762869aab22a82531b4addd69c5f99a5a70fe9",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_35.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_35.bin",
        "scope": "webllm/model",
        "bytes": 33214464,
        "hash": "37c83d9e2aced4e06b47a66949ee46739c1f3ee886e4d636451ce3398d475aec",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_36.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_36.bin",
        "scope": "webllm/model",
        "bytes": 33177600,
        "hash": "b4f6efb00fe5b980247113a237716ed7cbf7e2c0916df04f11d5336e605656d2",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_37.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_37.bin",
        "scope": "webllm/model",
        "bytes": 21233664,
        "hash": "4621079bbd437ad829b4bbd4c440c0946577d12473e22c2445333eeebb7f8cc0",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_38.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_38.bin",
        "scope": "webllm/model",
        "bytes": 33214464,
        "hash": "b7f6319235c75961aac662b54c3e53449179853248f0fd37c206016692064309",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_39.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_39.bin",
        "scope": "webllm/model",
        "bytes": 21233664,
        "hash": "94d3ad928dd89fa12fc121496bd2921fcd8423ab2028ffa263a0382a9129ddc7",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_4.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_4.bin",
        "scope": "webllm/model",
        "bytes": 33214464,
        "hash": "777c42b74885908c34acdace1a30c3568e1a4c26c9c848684594f82d33685d63",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_40.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_40.bin",
        "scope": "webllm/model",
        "bytes": 31882752,
        "hash": "70e8465d49ca5034ea63babfa4f675b862a8b06816f2b5e186900462a56418c8",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_41.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_41.bin",
        "scope": "webllm/model",
        "bytes": 2658816,
        "hash": "79d86752256cd5c3ec34b8fb50614cb2061b837a3bc1470ee78b345d7355144b",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_5.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_5.bin",
        "scope": "webllm/model",
        "bytes": 33177600,
        "hash": "a5a88ef51c0ef70ac89ff1d0e40ddf2058b4d1d1777124da48ad3038c7b2570d",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_6.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_6.bin",
        "scope": "webllm/model",
        "bytes": 21233664,
        "hash": "88b6de78f091654e9b696f0ce7556af30e2fc9c27ed986974a66a49528ab003b",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_7.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_7.bin",
        "scope": "webllm/model",
        "bytes": 33214464,
        "hash": "4fb47f358249640da350351e8b4877d672c9745adbbdf1d4a7c1253c2270e6a2",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_8.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_8.bin",
        "scope": "webllm/model",
        "bytes": 33177600,
        "hash": "4e90b66eea9090fdcf55bda8df95761b3768411c8ab06f5079ff575ee6402d77",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "params_shard_9.bin",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/params_shard_9.bin",
        "scope": "webllm/model",
        "bytes": 21233664,
        "hash": "af4e59dc895a9e5c2a15b494b1cd31dcd314f9cc9607bfbee36c4e2511795d4f",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "tensor-cache.json",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/tensor-cache.json",
        "scope": "webllm/model",
        "bytes": 128686,
        "hash": "f17bd3525ccf25f6e959a1673503314a99e059c3",
        "hashAlgorithm": "git-sha1"
      },
      {
        "path": "tokenizer.json",
        "url": "https://huggingface.co/mlc-ai/gemma-2-2b-it-q4f16_1-MLC/resolve/de9cc76f0d4b3a49a0f718df424944054bf1eec1/tokenizer.json",
        "scope": "webllm/model",
        "bytes": 17525357,
        "hash": "3f289bc05132635a8bc7aca7aa21255efd5e18f3710f43e3cdb96bcd41be4922",
        "hashAlgorithm": "sha256"
      },
      {
        "path": "gemma-2-2b-it-q4f16_1_cs1k-webgpu.wasm",
        "url": "https://raw.githubusercontent.com/mlc-ai/binary-mlc-llm-libs/025bcaf3780fa8254f5e5efd3bfea0a5397248f4/web-llm-models/v0_2_84/base/gemma-2-2b-it-q4f16_1_cs1k-webgpu.wasm",
        "scope": "webllm/wasm",
        "bytes": 5197217,
        "hash": "14b99638164dc878f760c2f52184a2eb6efbb13c",
        "hashAlgorithm": "git-sha1"
      }
    ],
    "termsNotice": "Gemma 2 is governed by Google’s Gemma Terms of Use and prohibited-use policy. Review those linked terms before downloading. The public converted model remains subject to those terms.",
    "downloadBytes": 1493768395
  }
];

export function findModel(id) {
  const model = models.find((item) => item.id === id);
  if (!model) throw Object.assign(new Error("Choose a model offered by this build."), { code: "unknownModel" });
  return model;
}

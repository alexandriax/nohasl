import { error } from './cache.js';

/** App code has a separate lifetime from downloaded model artifacts. Updating
 * the app must not make hundreds of MB of valid model files appear missing. */
export class RuntimeCache {
  constructor({ url, hash, bytes, storage = globalThis.caches,
    fetchFile = globalThis.fetch.bind(globalThis), crypto = globalThis.crypto }) {
    this.url = url;
    this.hash = hash;
    this.bytes = bytes;
    this.storage = storage;
    this.fetchFile = fetchFile;
    this.crypto = crypto;
  }

  valid(response) {
    return !!response && response.ok &&
      response.headers.get('x-nohasl-runtime-sha256') === this.hash &&
      response.headers.get('content-length') === String(this.bytes);
  }

  updateRequired() {
    return error('runtimeUpdateRequired',
      `Connect once to install this app’s updated local runtime (about ${Math.ceil(this.bytes / 1000000)} MB), then choose Use model again. Your downloaded model files are preserved.`);
  }

  async source({ allowInstall = false, signal } = {}) {
    const cache = await this.storage.open('nohasl/local-model-runtime-v1');
    let response = await cache.match(this.url);
    if (!this.valid(response)) {
      if (!allowInstall) throw this.updateRequired();
      try {
        // The URL is the one fixed same-origin application asset from build.mjs.
        // This method accepts no model URL and cannot download model artifacts.
        response = await this.fetchFile(this.url, { signal, credentials: 'same-origin' });
      } catch (cause) {
        if (signal?.aborted || cause?.name === 'AbortError') throw cause;
        throw this.updateRequired();
      }
      if (!response.ok) {
        throw error('runtimeMissing', 'The updated local runtime is missing from this app build. Refresh the app and retry. Your downloaded model files are preserved.');
      }
      const bytes = await response.arrayBuffer();
      signal?.throwIfAborted();
      const digest = new Uint8Array(await this.crypto.subtle.digest('SHA-256', bytes));
      const hash = Array.from(digest, (part) => part.toString(16).padStart(2, '0')).join('');
      if (bytes.byteLength !== this.bytes || hash !== this.hash) {
        throw error('runtimeMissing', 'The local model runtime does not match this app build. Refresh the app and retry.');
      }
      response = new Response(bytes, { headers: {
        'content-type': 'text/javascript', 'content-length': String(this.bytes),
        'x-nohasl-runtime-sha256': this.hash,
      } });
      signal?.throwIfAborted();
      await cache.put(this.url, response.clone());
    }
    const source = await response.text();
    signal?.throwIfAborted();
    return source;
  }
}

import { build } from 'esbuild';
import { createHash } from 'node:crypto';
import { mkdir, readFile, readdir, rm, writeFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';

const output = fileURLToPath(new URL('../../web/local_models/', import.meta.url));
const source = fileURLToPath(new URL('./src/', import.meta.url));
await mkdir(output, { recursive: true });
const result = await build({
  entryPoints: [`${source}/worker.js`], bundle: true, write: false,
  format: 'iife', platform: 'browser', target: ['es2022'], minify: true,
  legalComments: 'inline', metafile: true,
});
for (const entry of Object.values(result.metafile.outputs)) {
  if (entry.imports.length) throw new Error('The worker must not have any runtime module imports.');
}
const worker = result.outputFiles[0].contents;
const hash = createHash('sha256').update(worker).digest('hex');
const workerFile = `worker-${hash.slice(0, 16)}.js`;
for (const name of await readdir(output)) {
  if (/^worker-[a-f0-9]+\.js$/.test(name) && name !== workerFile) await rm(`${output}/${name}`);
}
await writeFile(`${output}/${workerFile}`, worker);
await build({
  entryPoints: [`${source}/bridge.js`], bundle: true,
  outfile: `${output}/bridge.js`, format: 'iife', platform: 'browser',
  target: ['es2022'], minify: true, legalComments: 'inline',
  define: {
    __NOHASL_WORKER_FILE__: JSON.stringify(workerFile),
    __NOHASL_WORKER_HASH__: JSON.stringify(hash),
    __NOHASL_WORKER_BYTES__: String(worker.byteLength),
  },
});
const license = await readFile(new URL('./node_modules/@mlc-ai/web-llm/LICENSE', import.meta.url), 'utf8');
await writeFile(`${output}/WEBLLM-LICENSE.txt`, license);
const mitLicense = await readFile(new URL('./node_modules/loglevel/LICENSE-MIT', import.meta.url), 'utf8');
const upstreamSource = await readFile(new URL('./node_modules/@mlc-ai/web-llm/lib/index.js', import.meta.url), 'utf8');
const notices = [...new Set((upstreamSource.match(/\/\*[\s\S]*?\*\//g) ?? [])
  .filter((comment) => /copyright|licensed|license/i.test(comment)))];
await writeFile(`${output}/THIRD-PARTY-NOTICES.txt`,
  'Bundled @mlc-ai/web-llm 0.2.84. Apache 2.0 license: WEBLLM-LICENSE.txt.\n\n' +
  mitLicense + '\n\nUpstream source notices preserved below:\n\n' + notices.join('\n\n') + '\n');
await writeFile(`${output}/MODEL-NOTICES.txt`,
  'No model weights are included in this application bundle. Downloads are optional.\n\n' +
  'SmolLM2-360M-Instruct: Hugging Face, Apache License 2.0.\n' +
  'Model card: https://huggingface.co/HuggingFaceTB/SmolLM2-360M-Instruct\n' +
  'License text: WEBLLM-LICENSE.txt (Apache License 2.0).\n\n' +
  'Gemma 2: Google. Gemma is provided under and subject to the Gemma Terms of Use found at ai.google.dev/gemma/terms.\n' +
  'Terms: https://ai.google.dev/gemma/terms\n' +
  'Prohibited use policy: https://ai.google.dev/gemma/prohibited_use_policy\n' +
  'Converted public weights remain subject to those terms. Review them before downloading.\n');
await writeFile(`${output}/runtime-manifest.json`, JSON.stringify({
  webllmVersion: '0.2.84', workerFile, sha256: hash, bytes: worker.byteLength,
}, null, 2) + '\n');
console.log(`Built ${workerFile} (${worker.byteLength.toLocaleString()} bytes); bridge has no CDN imports.`);

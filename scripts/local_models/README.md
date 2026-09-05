# Browser local model runtime

Source for the bundled browser worker and Dart JSON bridge. See
[operations, catalog, and verification notes](../../docs/WEB_LOCAL_MODELS.md).

```sh
npm ci --ignore-scripts
npm test
npm run build
```

Commit the generated `../../web/local_models/` files together with changes to
these sources. No model weights are included in the bundle. Do not substitute a
floating model revision, runtime CDN import, or unverified cache-completion flag.

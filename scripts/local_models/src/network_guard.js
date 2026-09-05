import { error } from './cache.js';

/** Install only inside our dedicated worker. Cache.add does its own browser
 * fetch and does not call global fetch, so both paths must be blocked. */
export function installCacheOnlyNetworkGuard(scope) {
  const explicitDownloadFetch = scope.fetch.bind(scope);
  const denied = async () => {
    throw error('missingCache', 'A required model file is missing from browser storage. Download the model again.');
  };
  scope.fetch = denied;
  if (scope.Cache) {
    scope.Cache.prototype.add = denied;
    scope.Cache.prototype.addAll = denied;
  }
  return explicitDownloadFetch;
}

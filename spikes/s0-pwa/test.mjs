import assert from 'node:assert/strict';
import fs from 'node:fs';
import { fileURLToPath } from 'node:url';
import path from 'node:path';
import { canonicalize, fnv1a64, runScenario } from './core.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
const fixture = JSON.parse(fs.readFileSync(path.join(here, '../shared-spec/fixture/spike_v0_01.json')));
const expected = JSON.parse(fs.readFileSync(path.join(here, '../shared-spec/expected/spike_v0_01_end_state.json')));
const result = runScenario(fixture);
assert.equal(result.semanticHash(), fnv1a64(JSON.stringify(canonicalize(expected))));
assert.deepEqual(result.state.facts.map((fact) => fact.kind), fixture.expected_fact_kinds);

const html = fs.readFileSync(path.join(here, 'web/index.html'), 'utf8');
for (const requiredId of ['world-day', 'player-name', 'goal-input', 'goal-submit', 'pause-toggle', 'save-world', 'load-world', 'history']) {
  assert.match(html, new RegExp('id="' + requiredId + '"'));
}
const manifest = JSON.parse(fs.readFileSync(path.join(here, 'web/manifest.json')));
assert.equal(manifest.display, 'standalone');
const conditions = JSON.parse(fs.readFileSync(path.join(here, '../shared-spec/conditions/spike_v0.json')));
assert.equal(conditions.schema_version, 1);
assert.equal(new Set(conditions.conditions.map((condition) => condition.id)).size, conditions.conditions.length);
assert.equal(conditions.conditions.filter((condition) => condition.status === 'pass').length, 7);
console.log('S0 PWA tests passed.');

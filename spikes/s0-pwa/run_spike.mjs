import fs from 'node:fs';
import os from 'node:os';
import { performance } from 'node:perf_hooks';
import { fileURLToPath } from 'node:url';
import path from 'node:path';
import { fnv1a64, canonicalize, runScenario } from './core.mjs';

const here = path.dirname(fileURLToPath(import.meta.url));
const fixture = JSON.parse(fs.readFileSync(path.join(here, '../shared-spec/fixture/spike_v0_01.json')));
const expected = JSON.parse(fs.readFileSync(path.join(here, '../shared-spec/expected/spike_v0_01_end_state.json')));
const expectedHash = fnv1a64(JSON.stringify(canonicalize(expected)));
const samples = [];
let result;
for (let index = 0; index < 500; index++) {
  const start = performance.now();
  result = runScenario(fixture);
  samples.push(Math.round((performance.now() - start) * 1000));
}
samples.sort((a, b) => a - b);
const percentile = (fraction) => samples[Math.round((samples.length - 1) * fraction)];
const actualHash = result.semanticHash();
const factKinds = result.state.facts.map((fact) => fact.kind);
if (actualHash !== expectedHash) throw new Error('PWA hash mismatch: ' + actualHash + ' != ' + expectedHash);
if (JSON.stringify(factKinds) !== JSON.stringify(fixture.expected_fact_kinds)) throw new Error('PWA trace mismatch.');

const evidence = {
  evidence_schema_version: 1,
  scenario_id: fixture.scenario_id,
  candidate: 'S0-PWA-JavaScript',
  runtime: 'Node ' + process.version + ' diagnostic runner',
  os: os.platform() + ' ' + os.release(),
  architecture: os.arch(),
  iterations: samples.length,
  expected_hash: expectedHash,
  actual_hash: actualHash,
  fact_kinds: factKinds,
  p50_microseconds: percentile(0.50),
  p95_microseconds: percentile(0.95),
  status: 'pass',
  scope_note: 'Diagnostic V0 subset; browser lifecycle and full SPIKE-W0-01 not tested.',
};
const evidencePath = path.join(here, '../evidence/s0-pwa-v0.json');
fs.mkdirSync(path.dirname(evidencePath), { recursive: true });
fs.writeFileSync(evidencePath, JSON.stringify(evidence, null, 2));
console.log(JSON.stringify(evidence, null, 2));

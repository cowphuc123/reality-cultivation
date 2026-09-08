import 'dart:convert';
import 'dart:io';

import 'package:reality_cultivation/reality_cultivation.dart';

const String fixturePath = '../spikes/shared-spec/fixture/spike_v0_01.json';
const String expectedPath =
    '../spikes/shared-spec/expected/spike_v0_01_end_state.json';
const String evidencePath = '../spikes/evidence/s2-dart-v0.json';

Map<String, Object?> readJson(String path) =>
    (jsonDecode(File(path).readAsStringSync()) as Map).cast<String, Object?>();

Simulation runScenario(Map<String, Object?> fixture) {
  final Map<String, Object?> birth = (fixture['birth']! as Map)
      .cast<String, Object?>();
  final Map<String, Object?> command = (fixture['command']! as Map)
      .cast<String, Object?>();
  final Simulation simulation = Simulation.fromSeed(fixture['seed']! as int);
  simulation.schedule(
    due: SimTime(birth['time_seconds']! as int),
    phase: EventPhase.completion,
    kind: 'birth',
    payload: <String, Object?>{
      'person_id': birth['person_id'],
      'name': birth['name'],
    },
  );
  simulation.advanceTo(SimTime(birth['time_seconds']! as int));
  simulation.issue(
    SetGoalCommand(
      id: command['id']! as String,
      personId: command['person_id']! as String,
      goal: command['goal']! as String,
    ),
  );
  for (final Object? value in fixture['events']! as List<Object?>) {
    final Map<String, Object?> event = (value! as Map).cast<String, Object?>();
    simulation.schedule(
      due: SimTime(event['due_seconds']! as int),
      phase: EventPhase.values.byName(event['phase']! as String),
      kind: event['kind']! as String,
      payload: (event['payload']! as Map).cast<String, Object?>(),
    );
  }
  final Simulation restored = Simulation.fromSave(simulation.state.save());
  restored.advanceTo(SimTime(fixture['advance_to_seconds']! as int));
  return restored;
}

int percentile(List<int> sortedValues, double fraction) {
  final int index = ((sortedValues.length - 1) * fraction).round();
  return sortedValues[index];
}

void main() {
  final Map<String, Object?> fixture = readJson(fixturePath);
  final String expectedSource = File(expectedPath).readAsStringSync();
  final String expectedHash = WorldState.load(expectedSource).semanticHash();
  final List<int> samples = <int>[];
  late Simulation result;
  for (int iteration = 0; iteration < 500; iteration++) {
    final Stopwatch watch = Stopwatch()..start();
    result = runScenario(fixture);
    watch.stop();
    samples.add(watch.elapsedMicroseconds);
  }
  samples.sort();
  final List<String> factKinds = result.state.facts
      .map((WorldFact fact) => fact.kind)
      .toList(growable: false);
  final List<String> expectedKinds =
      (fixture['expected_fact_kinds']! as List<Object?>).cast<String>();
  final String actualHash = result.state.semanticHash();
  if (actualHash != expectedHash) {
    throw StateError(
      'Dart hash mismatch: ' + actualHash + ' != ' + expectedHash,
    );
  }
  if (jsonEncode(factKinds) != jsonEncode(expectedKinds)) {
    throw StateError('Dart trace mismatch.');
  }

  final Map<String, Object?> evidence = <String, Object?>{
    'evidence_schema_version': 1,
    'scenario_id': fixture['scenario_id'],
    'candidate': 'S2-Dart-core',
    'runtime': 'Dart 3.10.7 JIT',
    'os': Platform.operatingSystem + ' ' + Platform.operatingSystemVersion,
    'architecture': Platform.version.contains('x64') ? 'x64' : 'unknown',
    'iterations': samples.length,
    'expected_hash': expectedHash,
    'actual_hash': actualHash,
    'fact_kinds': factKinds,
    'p50_microseconds': percentile(samples, 0.50),
    'p95_microseconds': percentile(samples, 0.95),
    'status': 'pass',
    'scope_note': 'Diagnostic V0 subset; not full SPIKE-W0-01 or release/AOT.',
  };
  File(evidencePath)
    ..createSync(recursive: true)
    ..writeAsStringSync(const JsonEncoder.withIndent('  ').convert(evidence));
  stdout.writeln(const JsonEncoder.withIndent('  ').convert(evidence));
}

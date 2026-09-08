import 'dart:convert';
import 'dart:io';

import 'package:reality_cultivation/reality_cultivation.dart';

void expectTrue(bool condition, String message) {
  if (!condition) throw StateError(message);
}

Simulation newbornSimulation() {
  final Simulation simulation = Simulation.fromSeed(20260906);
  simulation.schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'birth',
    payload: const <String, Object?>{'person_id': 'P00', 'name': 'Vô Danh'},
  );
  simulation.advanceTo(const SimTime(0));
  return simulation;
}

void verifyClock() {
  final Simulation simulation = newbornSimulation();
  final SimulationClock clock = SimulationClock(
    simulation: simulation,
    maxDaysPerPump: 2,
  );

  clock.pump(const Duration(seconds: 10));
  expectTrue(simulation.state.now.day == 0, 'Paused clock advanced time.');

  clock.resume();
  clock.pump(const Duration(milliseconds: 4999));
  expectTrue(simulation.state.now.day == 0, 'Clock advanced before 5000 ms.');
  final ClockPulse firstDay = clock.pump(const Duration(milliseconds: 1));
  expectTrue(firstDay.daysAdvanced == 1, '5000 ms did not advance one day.');
  expectTrue(simulation.state.now.day == 1, 'World did not reach day one.');

  clock.pause();
  clock.pump(const Duration(seconds: 5));
  expectTrue(simulation.state.now.day == 1, 'Pause consumed wall time.');

  clock.resume();
  final ClockPulse limited = clock.pump(const Duration(seconds: 25));
  expectTrue(limited.daysAdvanced == 2, 'Per-pump work limit was ignored.');
  expectTrue(
    limited.pendingRealMicroseconds ==
        const Duration(seconds: 15).inMicroseconds,
    'Backlog was discarded.',
  );
  final ClockPulse catchUp = clock.pump(Duration.zero);
  expectTrue(catchUp.daysAdvanced == 2, 'Backlog was not resumed.');
  expectTrue(
    simulation.state.now.day == 5,
    'Clock catch-up reached wrong day.',
  );
}

int verifyArtifacts() {
  final Map<String, Object?> schema =
      (jsonDecode(
                File(
                  'artifacts/schemas/condition_catalog.schema.json',
                ).readAsStringSync(),
              )
              as Map)
          .cast<String, Object?>();
  final Map<String, Object?> catalog =
      (jsonDecode(File('artifacts/conditions/v0.json').readAsStringSync())
              as Map)
          .cast<String, Object?>();
  final List<String> catalogFields =
      (schema['required_catalog_fields']! as List<Object?>).cast<String>();
  final List<String> conditionFields =
      (schema['required_condition_fields']! as List<Object?>).cast<String>();
  for (final String field in catalogFields) {
    expectTrue(
      catalog.containsKey(field),
      'Catalog is missing field: ' + field,
    );
  }
  final List<Object?> conditions = catalog['conditions']! as List<Object?>;
  expectTrue(conditions.isNotEmpty, 'Condition catalog is empty.');
  final Set<String> ids = <String>{};
  for (final Object? value in conditions) {
    final Map<String, Object?> condition = (value! as Map)
        .cast<String, Object?>();
    for (final String field in conditionFields) {
      expectTrue(
        condition.containsKey(field),
        'Condition is missing field: ' + field,
      );
    }
    expectTrue(
      ids.add(condition['id']! as String),
      'Condition ID is duplicated.',
    );
  }

  final Map<String, Object?> saveSchema =
      (jsonDecode(
                File(
                  'artifacts/schemas/save_v1.schema.json',
                ).readAsStringSync(),
              )
              as Map)
          .cast<String, Object?>();
  final List<String> saveFields =
      (saveSchema['required_fields']! as List<Object?>).cast<String>();
  final Map<String, Object?> save =
      (jsonDecode(newbornSimulation().state.save()) as Map)
          .cast<String, Object?>();
  for (final String field in saveFields) {
    expectTrue(save.containsKey(field), 'Save is missing field: ' + field);
  }
  return conditions.length;
}

void main() {
  verifyClock();
  final int automatedConditions = verifyArtifacts();

  final Simulation simulation = newbornSimulation();
  expectTrue(
    simulation.state.people.containsKey('P00'),
    'Birth was not applied.',
  );

  const SetGoalCommand goal = SetGoalCommand(
    id: 'command-goal-0',
    personId: 'P00',
    goal: 'Lắng nghe người chăm sóc',
  );
  final SimulationHost host = SimulationHost(simulation);
  expectTrue(host.submit(goal).accepted, 'First command must be accepted.');
  expectTrue(
    host.submit(goal).status == CommandStatus.duplicate,
    'Duplicate command must be reported.',
  );
  final PersonView personView = host.person('P00')!;
  expectTrue(
    personView.activeGoal == goal.goal,
    'Query port did not expose the active goal.',
  );
  expectTrue(
    host.world().personCount == 1,
    'World view has wrong person count.',
  );

  simulation.schedule(
    due: const SimTime(5),
    phase: EventPhase.observation,
    kind: 'observe',
    payload: const <String, Object?>{'subject': 'caregiver'},
  );
  simulation.schedule(
    due: const SimTime(5),
    phase: EventPhase.transfer,
    kind: 'transfer',
    payload: const <String, Object?>{'item': 'warmth'},
  );

  final String save = simulation.state.save();
  final Simulation restored = Simulation.fromSave(save);
  simulation.advanceTo(const SimTime(gameSecondsPerDay));
  restored.advanceTo(const SimTime(gameSecondsPerDay));

  expectTrue(
    simulation.state.semanticHash() == restored.state.semanticHash(),
    'Save/load continuation changed semantic state.',
  );
  final List<String> kinds = simulation.state.facts
      .map((WorldFact fact) => fact.kind)
      .toList(growable: false);
  expectTrue(
    kinds.indexOf('transfer') < kinds.indexOf('observe'),
    'Same-time events violated phase order.',
  );
  expectTrue(
    jsonDecode(simulation.state.save()) is Map<String, dynamic>,
    'Save is not valid JSON.',
  );

  final Simulation replay = newbornSimulation();
  replay.issue(goal);
  replay.schedule(
    due: const SimTime(5),
    phase: EventPhase.observation,
    kind: 'observe',
    payload: const <String, Object?>{'subject': 'caregiver'},
  );
  replay.schedule(
    due: const SimTime(5),
    phase: EventPhase.transfer,
    kind: 'transfer',
    payload: const <String, Object?>{'item': 'warmth'},
  );
  replay.advanceTo(const SimTime(gameSecondsPerDay));
  expectTrue(
    simulation.state.semanticHash() == replay.state.semanticHash(),
    'Same seed and commands did not replay deterministically.',
  );

  print('V0 verification passed.');
  print('Catalog conditions: ' + automatedConditions.toString());
  print('Semantic hash: ' + simulation.state.semanticHash());
}

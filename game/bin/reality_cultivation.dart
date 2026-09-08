import 'package:reality_cultivation/reality_cultivation.dart';

void main() {
  final Simulation simulation = Simulation.fromSeed(20260906);
  simulation.schedule(
    due: const SimTime(0),
    phase: EventPhase.completion,
    kind: 'birth',
    payload: const <String, Object?>{'person_id': 'P00', 'name': 'Vô Danh'},
  );
  simulation.advanceTo(const SimTime(0));
  final SimulationHost host = SimulationHost(simulation);
  host.submit(
    const SetGoalCommand(
      id: 'command-0',
      personId: 'P00',
      goal: 'Quan sát giọng nói của người chăm sóc',
    ),
  );
  final SimulationClock clock = SimulationClock(simulation: simulation)
    ..resume();
  clock.pump(const Duration(milliseconds: realMillisecondsPerGameDay));

  final PersonView player = host.person('P00')!;
  final WorldView world = host.world();
  print('Reality Cultivation — lõi mô phỏng V0');
  print('Ngày trong game: ' + world.time.day.toString());
  print('Nhân vật: ' + player.name);
  print('Mục tiêu: ' + (player.activeGoal ?? 'chưa có'));
  print('Sự kiện đã ghi: ' + world.factCount.toString());
  print('Dấu vân tay trạng thái: ' + world.semanticHash);
}

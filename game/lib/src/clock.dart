import 'dart:async';

import 'simulation.dart';

class ClockPulse {
  const ClockPulse({
    required this.daysAdvanced,
    required this.pendingRealMicroseconds,
    required this.paused,
  });

  final int daysAdvanced;
  final int pendingRealMicroseconds;
  final bool paused;
}

class SimulationClock {
  SimulationClock({
    required this.simulation,
    this.realDayDuration = const Duration(
      milliseconds: realMillisecondsPerGameDay,
    ),
    this.maxDaysPerPump = 32,
  }) {
    if (realDayDuration <= Duration.zero) {
      throw ArgumentError.value(realDayDuration, 'realDayDuration');
    }
    if (maxDaysPerPump <= 0) {
      throw ArgumentError.value(maxDaysPerPump, 'maxDaysPerPump');
    }
  }

  final Simulation simulation;
  final Duration realDayDuration;
  final int maxDaysPerPump;

  bool _paused = true;
  int _pendingRealMicroseconds = 0;

  bool get paused => _paused;
  int get pendingRealMicroseconds => _pendingRealMicroseconds;

  void pause() => _paused = true;
  void resume() => _paused = false;

  ClockPulse pump(Duration elapsed) {
    if (elapsed.isNegative) throw ArgumentError.value(elapsed, 'elapsed');
    if (_paused) {
      return ClockPulse(
        daysAdvanced: 0,
        pendingRealMicroseconds: _pendingRealMicroseconds,
        paused: true,
      );
    }

    _pendingRealMicroseconds += elapsed.inMicroseconds;
    final int availableDays =
        _pendingRealMicroseconds ~/ realDayDuration.inMicroseconds;
    final int daysToAdvance = availableDays > maxDaysPerPump
        ? maxDaysPerPump
        : availableDays;
    if (daysToAdvance > 0) {
      _pendingRealMicroseconds -=
          daysToAdvance * realDayDuration.inMicroseconds;
      simulation.advanceTo(simulation.state.now.addDays(daysToAdvance));
    }
    return ClockPulse(
      daysAdvanced: daysToAdvance,
      pendingRealMicroseconds: _pendingRealMicroseconds,
      paused: false,
    );
  }
}

class RealTimeSimulationRunner {
  RealTimeSimulationRunner({
    required this.clock,
    this.pollInterval = const Duration(milliseconds: 100),
    this.onPulse,
  });

  final SimulationClock clock;
  final Duration pollInterval;
  final void Function(ClockPulse pulse)? onPulse;

  Timer? _timer;
  Stopwatch? _stopwatch;

  bool get running => _timer != null;

  void start() {
    if (running) return;
    clock.resume();
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(pollInterval, (_) => _tick());
  }

  void pause() {
    _settleElapsed();
    clock.pause();
    _stopwatch?.stop();
    _timer?.cancel();
    _timer = null;
    _stopwatch = null;
  }

  void stop() => pause();

  void _tick() => _settleElapsed();

  void _settleElapsed() {
    final Stopwatch? watch = _stopwatch;
    if (watch == null) return;
    final Duration elapsed = watch.elapsed;
    watch.reset();
    final ClockPulse pulse = clock.pump(elapsed);
    onPulse?.call(pulse);
  }
}

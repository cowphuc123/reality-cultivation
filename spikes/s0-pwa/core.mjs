const phaseOrder = {
  intent: 20,
  movement: 30,
  transfer: 50,
  completion: 60,
  observation: 70,
  bookkeeping: 80,
};

function eventCompare(a, b) {
  return a.due.seconds - b.due.seconds ||
    phaseOrder[a.phase] - phaseOrder[b.phase] ||
    a.sequence - b.sequence;
}

export function canonicalize(value) {
  if (Array.isArray(value)) return value.map(canonicalize);
  if (value && typeof value === 'object') {
    return Object.fromEntries(
      Object.keys(value).sort().map((key) => [key, canonicalize(value[key])]),
    );
  }
  return value;
}

export function fnv1a64(value) {
  const bytes = new TextEncoder().encode(value);
  const mask = (1n << 64n) - 1n;
  let hash = 0xcbf29ce484222325n;
  for (const byte of bytes) {
    hash ^= BigInt(byte);
    hash = (hash * 0x100000001b3n) & mask;
  }
  return hash.toString(16).padStart(16, '0');
}

export class Simulation {
  constructor(seedOrState) {
    this.state = typeof seedOrState === 'number'
      ? {
          schema_version: 1,
          seed: seedOrState,
          now: { seconds: 0 },
          revision: 0,
          next_sequence: 0,
          people: [],
          pending_events: [],
          facts: [],
          accepted_command_ids: [],
        }
      : structuredClone(seedOrState);
  }

  static load(source) {
    const state = JSON.parse(source);
    if (state.schema_version !== 1) throw new Error('Unsupported save schema.');
    return new Simulation(state);
  }

  schedule(dueSeconds, phase, kind, payload) {
    if (dueSeconds < this.state.now.seconds) throw new Error('Past event.');
    const sequence = this.state.next_sequence;
    this.state.pending_events.push({
      id: 'event-' + sequence,
      due: { seconds: dueSeconds },
      phase,
      sequence,
      kind,
      payload: structuredClone(payload),
    });
    this.state.pending_events.sort(eventCompare);
    this.state.next_sequence = sequence + 1;
    this.state.revision++;
  }

  issueGoal(command) {
    if (this.state.accepted_command_ids.includes(command.id)) return false;
    const person = this.state.people.find((value) => value.id === command.person_id);
    if (!person) throw new Error('Unknown person.');
    person.active_goal = command.goal;
    this.state.accepted_command_ids.push(command.id);
    this.#addFact('goal_assigned', command.person_id, command.goal);
    this.state.revision++;
    return true;
  }

  advanceTo(seconds) {
    if (seconds < this.state.now.seconds) throw new Error('Time moved backwards.');
    while (this.state.pending_events.length &&
      this.state.pending_events[0].due.seconds <= seconds) {
      const event = this.state.pending_events.shift();
      this.state.now = structuredClone(event.due);
      this.#apply(event);
    }
    if (this.state.now.seconds < seconds) {
      this.state.now = { seconds };
      this.state.revision++;
    }
  }

  #apply(event) {
    if (event.kind === 'birth') {
      if (this.state.people.some((person) => person.id === event.payload.person_id)) return;
      this.state.people.push({
        id: event.payload.person_id,
        name: event.payload.name,
        birth_time: structuredClone(event.due),
        active_goal: null,
      });
      this.#addFact('birth', event.payload.person_id, event.payload.name + ' was born');
      this.state.revision++;
      return;
    }
    this.#addFact(event.kind, event.id, JSON.stringify(event.payload));
    this.state.revision++;
  }

  #addFact(kind, subjectId, detail) {
    this.state.facts.push({
      id: 'fact-' + (this.state.revision + 1),
      time: structuredClone(this.state.now),
      kind,
      subject_id: subjectId,
      detail,
    });
  }

  save() {
    const state = structuredClone(this.state);
    state.people.sort((a, b) => a.id.localeCompare(b.id));
    state.pending_events.sort(eventCompare);
    state.accepted_command_ids.sort();
    return JSON.stringify(state, null, 2);
  }

  semanticHash() {
    return fnv1a64(JSON.stringify(canonicalize(this.state)));
  }
}

export function runScenario(fixture) {
  const simulation = new Simulation(fixture.seed);
  const birth = fixture.birth;
  simulation.schedule(birth.time_seconds, 'completion', 'birth', {
    person_id: birth.person_id,
    name: birth.name,
  });
  simulation.advanceTo(birth.time_seconds);
  simulation.issueGoal(fixture.command);
  for (const event of fixture.events) {
    simulation.schedule(event.due_seconds, event.phase, event.kind, event.payload);
  }
  const restored = Simulation.load(simulation.save());
  restored.advanceTo(fixture.advance_to_seconds);
  return restored;
}

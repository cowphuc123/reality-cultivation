import { Simulation } from '../core.mjs';

const fixture = await fetch('../../shared-spec/fixture/spike_v0_01.json').then((response) => response.json());
let simulation = new Simulation(fixture.seed);
simulation.schedule(
  fixture.birth.time_seconds,
  'completion',
  'birth',
  { person_id: fixture.birth.person_id, name: fixture.birth.name },
);
simulation.advanceTo(fixture.birth.time_seconds);

let running = true;
let commandSequence = 0;
const elements = {
  day: document.querySelector('#world-day'),
  name: document.querySelector('#player-name'),
  goal: document.querySelector('#active-goal'),
  input: document.querySelector('#goal-input'),
  pause: document.querySelector('#pause-toggle'),
  history: document.querySelector('#history'),
};

function render() {
  const person = simulation.state.people[0];
  elements.day.textContent = 'Ngày ' + Math.floor(simulation.state.now.seconds / 86400);
  elements.name.textContent = person.name;
  elements.goal.textContent = 'Mục tiêu hiện tại: ' + (person.active_goal ?? 'Chưa có');
  elements.pause.textContent = running ? 'Tạm dừng' : 'Tiếp tục';
  elements.history.replaceChildren(...simulation.state.facts.toReversed().map((fact) => {
    const item = document.createElement('li');
    item.textContent = fact.kind + ' · ' + fact.detail;
    return item;
  }));
}

document.querySelector('#goal-submit').addEventListener('click', () => {
  const goal = elements.input.value.trim();
  if (!goal) return;
  simulation.issueGoal({
    id: 'pwa-goal-' + simulation.state.revision + '-' + commandSequence++,
    person_id: fixture.birth.person_id,
    goal,
  });
  elements.input.value = '';
  render();
});
elements.pause.addEventListener('click', () => {
  running = !running;
  render();
});
document.querySelector('#save-world').addEventListener('click', () => {
  localStorage.setItem('reality_cultivation.pwa_spike.v1', simulation.save());
});
document.querySelector('#load-world').addEventListener('click', () => {
  const source = localStorage.getItem('reality_cultivation.pwa_spike.v1');
  if (source) simulation = Simulation.load(source);
  render();
});
setInterval(() => {
  if (!running) return;
  simulation.advanceTo(simulation.state.now.seconds + 86400);
  render();
}, 5000);
if ('serviceWorker' in navigator) navigator.serviceWorker.register('service-worker.js');
render();

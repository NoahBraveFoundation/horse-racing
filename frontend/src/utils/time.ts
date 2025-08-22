export function formatTime(value: number): string {
  const ms = value > 1e12 ? value : value * 1000;
  const d = new Date(ms);
  return d.toLocaleTimeString(undefined, { hour: 'numeric', minute: '2-digit' });
}

export function formatTimeRange(start: number, end: number): string {
  return `${formatTime(start)} — ${formatTime(end)}`;
}

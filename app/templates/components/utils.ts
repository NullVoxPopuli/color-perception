// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error
import nearestColor from 'nearest-color';
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error
import { colornames } from 'color-name-list';

const colors = (colornames as Array<{ name: string; hex: string }>).reduce(
  (o, { name, hex }) => Object.assign(o, { [name]: hex }),
  {}
);

interface NearestFn {
  (color: string): { name: string };
}

const nearest: NearestFn = (
  nearestColor as { from(colors: unknown): NearestFn }
).from(colors);

export function nearestName(color: string) {
  const result = nearest(color);
  const name = result.name;

  return name;
}

// const defaultStart = '#ff0000';
// const defaultEnd = '#ff00ff';
export const defaultStart = '#00ff00';
export const defaultEnd = '#0000ff';

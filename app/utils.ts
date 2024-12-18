import { resource, resourceFactory } from 'ember-resources';
import { assert } from '@ember/debug';
import type { Registry } from '@ember/service';
import {
  convertLabToLch,
  parseHex,
  convertRgbToOklab,
  type Oklch,
} from 'culori';

// const defaultStart = '#ff0000';
// const defaultEnd = '#ff00ff';
const defaultStart = '#00ff00';
const defaultEnd = '#0000ff';

const defaults = {
  start: defaultStart,
  end: defaultEnd,
} as Record<string, string>;

export function qp(name: string) {
  return resource(({ owner }) => {
    const router = owner.lookup('service:router');
    const qpValue = router.currentRoute?.queryParams[name];

    assert(
      `expected qp to do be a string (or falsey). what witchcraft did you do?!?!`,
      typeof qpValue === 'string' || !qpValue
    );

    // eslint-disable-next-line @typescript-eslint/no-base-to-string
    return (qpValue ? String(qpValue) : defaults[name]) || '';
  });
}

// Needed until ember natively supports resources
resourceFactory(qp);

export function appValue<
  Name extends keyof Registry & string,
  Property extends keyof Registry[Name],
>(serviceName: Name, property: Property): Registry[Name][Property] {
  return resource(({ owner }) => {
    return owner.lookup(`service:${serviceName}`)?.[
      property
    ] as Registry[Name][Property];
  });
}

resourceFactory(appValue);

/**
 * Randomly chooses a value from the first third or the last third,
 * but ignores the middle third.
 */
export function selectRandomNonCenter(start: number, end: number): number {
  const rand = Math.random();
  const useFirstThird = rand < 0.5;
  const useLastThird = rand >= 0.5;
  const middle = [...middleThird(start, end).values()];
  // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
  const firstThird = middle[0]! - 1;
  // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
  const lastThird = middle.at(-1)! + 1;

  if (useFirstThird) {
    return selectRandomBetween(start, firstThird);
  }

  if (useLastThird) {
    return selectRandomBetween(lastThird, end);
  }

  assert(`Invalid random value ${String(rand)}`);
}

export function selectRandomBetween(start: number, end: number) {
  const rand = Math.random();
  const range = end - start;

  const result = rand * range + start;

  return Math.round(result);
}

/**
 * Return the integers in range of the middle third
 * between start and end.
 */
export function middleThird(start: number, end: number) {
  const range = end - start;
  const third = range / 3;

  const result = new Set<number>();

  for (let i = 0; i < third; i++) {
    const value = Math.round(start + third + i);
    result.add(value);
  }

  return result;
}

/**
 * Reflects over the midpoint created by start and end
 */
export function opposing(start: number, end: number, a: number) {
  const middle = (end - start) / 2 + start;

  const diff = Math.abs(a - middle);

  return a < middle ? middle + diff : middle - diff;
}

export function twoStopsForWindow(start: number, end: number, a: number) {
  const middle = (end - start) / 2 + start;

  const diff = Math.abs(a - middle);
  const delta = diff / 2;

  return [
    selectRandomBetween(start + delta, end - delta),
    selectRandomBetween(start + delta, end - delta),
  ];
}

export function colorFor(value: string | Oklch) {
  if (typeof value === 'string') {
    return value;
  }

  return `oklch(${value.l} ${value.c} ${value.h}deg)`;
}

export function hexRGBToOklch(hex: string) {
  const parsed = parseHex(hex);
  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  const oklab = convertRgbToOklab(parsed);
  const oklch = convertLabToLch(oklab, 'oklch');
  return oklch;
}

export function round10(num: number) {
  return Math.round(num * 10) / 10;
}

export function round100(num: number) {
  return Math.round(num * 100) / 100;
}

export function round1000(num: number) {
  return Math.round(num * 1000) / 1000;
}

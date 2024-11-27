import { parse, converter } from 'culori';
import nearestColor from 'nearest-color';
import { colornames } from 'color-name-list';

const colors = colornames.reduce(
  (o, { name, hex }) => Object.assign(o, { [name]: hex }),
  {}
);

const nearest = nearestColor.from(colors);

export function nearestName(color: string) {
  const result = nearest(color);
  const name = result.name;

  return name;
}

const lab = converter('lab');

export function hexRGBtoLCH(hex: string) {
  const rgb = parse(hex);

  return lab(rgb);
}

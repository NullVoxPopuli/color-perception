import Service from '@ember/service';
import { cached } from '@glimmer/tracking';
import { qp } from 'color-perception/utils';
import { use } from 'ember-resources';
import {
  interpolate,
  samples,
  parseHex,
  convertLabToLch,
  convertLrgbToOklab,
  type Oklch,
} from 'culori';

export const SEARCH_SIZE = 111;

export default class Stops extends Service {
  // Something is weird about the compilation
  // environment, because when @use is used as a decorator,
  // there *is* a third argument passed (as is standard
  // for the stage 2 decorator implementation,
  // but it seems that the third argument is undefined.
  // This is supposed to be the descriptor.
  #start = use(this, qp('start'));
  #end = use(this, qp('end'));

  get start() {
    return this.#start.current;
  }
  get end() {
    return this.#end.current;
  }

  get startOKLCH() {
    const parsed = parseHex(this.start);
    const oklab = convertLrgbToOklab(parsed);
    const oklch = convertLabToLch(oklab, 'oklch');
    return oklch;
  }
  get endOKLCH() {
    const parsed = parseHex(this.end);
    const oklab = convertLrgbToOklab(parsed);
    const oklch = convertLabToLch(oklab, 'oklch');
    return oklch;
  }

  @cached
  get interpolation() {
    return interpolate([this.start, this.end], 'oklch');
  }

  @cached
  get previewSamples() {
    return samples(5).map(this.interpolation);
  }

  @cached
  get range() {
    return samples(2).map(this.interpolation);
  }

  @cached
  get middleColor() {
    return this.previewSamples[2];
  }

  @cached
  get searchSpace() {
    const search = samples(SEARCH_SIZE + 3).map(this.interpolation);

    return search.slice(1, -1);
  }

  /**
   * return an exclusive range
   * for asking the viewer what
   * colors are
   */
  toCheck = (start: Oklch, end: Oklch) => {
    const interpolation = interpolate([start, end], 'oklch');

    const range = samples(4).map(interpolation);

    return range.slice(1, -1);
  };

  middleOf = (start: Oklch, end: Oklch) => {
    const interpolation = interpolate([start, end], 'oklch');
    const range = samples(3).map(interpolation);

    return range[1];
  };
}

declare module '@ember/service' {
  interface Registry {
    stops: Stops;
  }
}

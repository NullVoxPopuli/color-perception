import Service from '@ember/service';
import { cached } from '@glimmer/tracking';
import { qp } from 'color-perception/utils';
import { use } from 'ember-resources';
import { interpolate, samples } from 'culori';

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

  @cached
  get previewSamples() {
    const interpolator = interpolate([this.start, this.end], 'oklch');
    return samples(5).map(interpolator);
  }

  @cached
  get range() {
    const interpolator = interpolate([this.start, this.end], 'oklch');
    return [...samples(2).map(interpolator)];
  }
}

declare module '@ember/service' {
  interface Registry {
    stops: Stops;
  }
}

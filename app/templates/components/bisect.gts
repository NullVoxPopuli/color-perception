import Component from '@glimmer/component';
import { Color } from './color';
import type Stops from 'color-perception/services/stops';
import { service } from '@ember/service';

export class Bisect extends Component<{
  Args: { start: string; end: string };
}> {
  @service('stops') declare stops: Stops;

  get start() {
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    return this.stops.range[0]!;
  }

  choices = {};
  <template><Color @value={{this.start}} /></template>
}

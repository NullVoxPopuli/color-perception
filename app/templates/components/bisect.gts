import Component from '@glimmer/component';
import { Color } from './color';
import type Stops from 'color-perception/services/stops';
import { service } from '@ember/service';
import { Header } from './header';
import { nearestName } from './utils';
import { on } from '@ember/modifier';
import { cached, tracked } from '@glimmer/tracking';
import type { Oklch } from 'culori';
import { assert } from '@ember/debug';

export class Bisect extends Component<{
  Args: { start: string; end: string };
}> {
  @service('stops') declare stops: Stops;

  lastIndex = Infinity;
  @tracked currentIndex = 0;

  @cached
  get search() {
    const stops = this.stops.searchSpace;

    if (Math.random() > 0.5) {
      return stops;
    }

    return stops.reverse();
  }

  get leftName() {
    return nearestName(this.stops.start);
  }
  get rightName() {
    return nearestName(this.stops.end);
  }

  chooseLeft = () => {
    this.choices.set(this.currentIndex, this.leftName);
    this.next();
  };
  chooseRight = () => {
    this.choices.set(this.currentIndex, this.rightName);
    this.next();
  };

  next = () => {
    const total = this.search.length;
    const current = this.currentIndex;
    let last = this.lastIndex;

    if (last === Infinity) {
      last = total;
    }

    const nextIndex = Math.floor((current - last) / 3);
    console.log({ current, last, nextIndex });

    if (nextIndex < 0) {
      this.currentIndex = last + nextIndex;
    } else {
      this.currentIndex = nextIndex;
    }

    this.lastIndex = current;
    console.log(this.choices);
  };

  choices = new Map<number, string>();

  get currentColor() {
    const value = this.search[this.currentIndex];

    assert(`[Bug]: no value for index: ${String(this.currentIndex)}`, value);

    return value;
  }

  <template>
    <Color @value={{this.currentColor}}>
      <Header>
        <button {{on "click" this.chooseLeft}}>More {{this.leftName}}</button>
        <span>|</span>
        <button {{on "click" this.chooseRight}}>More {{this.rightName}}</button>
      </Header>
    </Color>
    <style>
      header {
        display: flex;
        justify-content: space-between;

        button,
        span {
          border: none;
          background: none;
          color: white;
          font-size: 2rem;
        }
        button {
          width: 100%;
        }
      }
    </style>
  </template>
}

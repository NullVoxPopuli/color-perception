import Component from '@glimmer/component';
import { Color } from './color';
import type Stops from 'color-perception/services/stops';
import { service } from '@ember/service';
import { Header } from './header';
import { nearestName } from './utils';
import { on } from '@ember/modifier';
import { cached, tracked } from '@glimmer/tracking';
import type { Oklch } from 'culori';
import { differenceHueChroma } from 'culori';
import { assert } from '@ember/debug';
import { TrackedArray } from 'tracked-built-ins';
import type RouterService from '@ember/routing/router-service';
import { SEARCH_SIZE } from 'color-perception/services/stops';
import { selectRandomNonCenter } from 'color-perception/utils';

export interface Choice {
  color: Oklch;
  choice: 'left' | 'right';
  isCorrect: boolean;
  actual: 'left' | 'right';
}

export class Bisect extends Component<{
  Args: { start: string; end: string; debug: boolean };
  Blocks: { default: [choices: Choice[], currentColor: Oklch] };
}> {
  @service('stops') declare stops: Stops;
  @service('router') declare router: RouterService;

  @tracked currentIndex = selectRandomNonCenter(0, SEARCH_SIZE);
  choices: Choice[] = new TrackedArray();
  seen = new Set<number>([this.currentIndex]);
  queue = new TrackedArray([this.currentIndex]);

  get currentColor() {
    const value = this.stops.searchSpace[this.currentIndex];

    assert(`[Bug]: no value for index: ${String(this.currentIndex)}`, value);

    return value;
  }

  get leftName() {
    return nearestName(this.stops.start);
  }
  get rightName() {
    return nearestName(this.stops.end);
  }

  chooseLeft = () => {
    this.next('left');
  };
  chooseRight = () => {
    this.next('right');
  };

  next = (chose: 'left' | 'right') => {
    const middle = SEARCH_SIZE / 2;
    const middles = [Math.ceil(middle), Math.floor(middle)];
    const currentIndex = this.currentIndex;
    const currentColor = this.currentColor;

    const isLeft = currentIndex < middle;
    const isRight = currentIndex > middle;

    const isWithin2OfMiddle = Math.abs(currentIndex - middle) <= 2;

    this.choices.push({
      color: currentColor,
      choice: chose,
      isCorrect: (chose === 'left' && isLeft) || (chose === 'right' && isRight),
      actual: isLeft ? 'left' : 'right',
    });

    console.log({
      isLeft,
      isRight,
    });

    if (isWithin2OfMiddle) {
      console.debug(
        `Difference of current pair is very small. Not adding more colors`
      );
      // Pair is very narrow already, no need to add more colors
      this.maybeFinish();
      return;
    }

    switch (chose) {
      case 'left': {
        // Correct
        if (isLeft) {
          console.debug(
            `Color chosen *is* more ${this.leftName}. Next colors will be closer to the middle`
          );
          // Get closer to center
          const stops = this.stops.toCheck(...currentPair);
          this.queue.push(...stops);
          break;
        }
        // Incorrect
        if (isRight) {
          console.debug(
            `Color chosen *is not* more ${this.leftName}. Next colors will be closer to the left side (${this.leftName})`
          );
          const middle = this.stops.middleOf(...currentPair);
          const stops = this.stops.toCheck(middle, this.stops.startOKLCH);
          this.queue.push(...stops);
          break;
        }
        break;
      }
      case 'right': {
        // Incorrect
        if (isLeft) {
          console.debug(
            `Color chosen *is not* more ${this.rightName}. Next colors will be closer to the left side (${this.rightName})`
          );
          const middle = this.stops.middleOf(...currentPair);
          const stops = this.stops.toCheck(middle, this.stops.endOKLCH);
          this.queue.push(...stops);
          break;
        }
        // Correct
        if (isRight) {
          console.debug(
            `Color chosen *is* more ${this.rightName}. Next colors will be closer to the middle`
          );
          // Get closer to center
          const stops = this.stops.toCheck(...currentPair);
          this.queue.push(...stops);
          break;
        }
      }
    }

    this.queue.shift();
    console.log(this.choices);

    this.maybeFinish();
  };

  maybeFinish() {
    if (this.queue.length === 0) {
      // We're done, calculate results
      this.finish();
      return;
    }
  }

  finish() {
    if (this.args.debug) {
      console.log('done');
      return;
    }
    this.router.transitionTo('results', {
      queryParams: {
        choices: this.choices,
      },
    });
  }

  <template>
    <Color class="color" @value={{this.currentColor}}>
      <Header>
        <button {{on "click" this.chooseLeft}}>More {{this.leftName}}</button>
        <span>|</span>
        <button {{on "click" this.chooseRight}}>More {{this.rightName}}</button>
      </Header>
    </Color>
    {{yield this.choices this.currentColor}}
    <style>
      .color {
        height: 100dvh;
        width: 100dvw;
      }
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

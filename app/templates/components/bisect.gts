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

  choices: Choice[] = new TrackedArray();

  @cached
  get startingPair() {
    let starting = this.stops.toCheck(this.stops.start, this.stops.end);

    if (Math.random() < 0.5) {
      starting = starting.reverse();
    }

    this.#recordPair(starting);

    return starting;
  }

  #pairs = new Map<Oklch, [Oklch, Oklch]>();
  #recordPair(pair: [Oklch, Oklch]) {
    this.#pairs.set(pair[0], pair);
    this.#pairs.set(pair[1], pair);
  }
  #opposing(color: Oklch) {
    let pair = this.#pairs.get(color);
    let opposing = pair.find((x) => x !== color);

    assert(`Could not find opposing`, opposing);

    return opposing;
  }

  @cached
  get queue() {
    return new TrackedArray(this.startingPair);
  }

  get currentColor() {
    const value = this.queue[0];

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
    let currentColor = this.currentColor;
    let currentPair = this.#pairs.get(currentColor);

    /**
     * NOTE: max distance is 0.6
     */

    let differenceOfPair = differenceHueChroma(...currentPair);
    let middleFromLeft = differenceHueChroma(
      this.stops.middleColor,
      this.stops.startOKLCH
    );
    let middleFromRight = differenceHueChroma(
      this.stops.middleColor,
      this.stops.endOKLCH
    );

    let distanceToLeft = differenceHueChroma(
      currentColor,
      this.stops.startOKLCH
    );
    let distanceOfRight = differenceHueChroma(
      currentColor,
      this.stops.endOKLCH
    );

    let isLeft = distanceToLeft < middleFromLeft;
    let isRight = distanceOfRight < middleFromRight;

    this.choices.push({
      color: currentColor,
      choice: chose,
      isCorrect: (chose === 'left' && isLeft) || (chose === 'right' && isRight),
      actual: isLeft ? 'left' : 'right',
    });

    console.log({
      isLeft,
      isRight,
      differenceOfPair,
      queue: [...this.queue],
    });

    if (Math.abs(differenceOfPair) < 0.05) {
      console.debug(
        `Difference of current pair is very small. Not adding more colors`
      );
      // Pair is very narrow already, no need to add more colors
      this.queue.shift();
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
          let stops = this.stops.toCheck(...currentPair);
          this.#recordPair(stops);
          this.queue.push(...stops);
          break;
        }
        // Incorrect
        if (isRight) {
          console.debug(
            `Color chosen *is not* more ${this.leftName}. Next colors will be closer to the left side (${this.leftName})`
          );
          let middle = this.stops.middleOf(...currentPair);
          let stops = this.stops.toCheck(middle, this.stops.startOKLCH);
          this.#recordPair(stops);
          this.queue.push(...stops);
          break;
        }
      }
      case 'right': {
        // Incorrect
        if (isLeft) {
          console.debug(
            `Color chosen *is not* more ${this.rightName}. Next colors will be closer to the left side (${this.rightName})`
          );
          let middle = this.stops.middleOf(...currentPair);
          let stops = this.stops.toCheck(middle, this.stops.endOKLCH);
          this.#recordPair(stops);
          this.queue.push(...stops);
          break;
        }
        // Correct
        if (isRight) {
          console.debug(
            `Color chosen *is* more ${this.rightName}. Next colors will be closer to the middle`
          );
          // Get closer to center
          let stops = this.stops.toCheck(...currentPair);
          this.#recordPair(stops);
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
      return this.finish();
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

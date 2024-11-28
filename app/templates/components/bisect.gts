import Component from '@glimmer/component';
import { Color } from './color';
import type Stops from 'color-perception/services/stops';
import { service } from '@ember/service';
import { Header } from './header';
import { nearestName } from './utils';
import { on } from '@ember/modifier';
import { hash } from '@ember/helper';
import type { Oklch } from 'culori';
import { formatHex } from 'culori';
import { assert } from '@ember/debug';
import { TrackedArray } from 'tracked-built-ins';
import type RouterService from '@ember/routing/router-service';
import { SEARCH_SIZE } from 'color-perception/services/stops';
import { link } from 'reactiveweb/link';
import { Window } from './window';

export interface Choice {
  color: Oklch;
  choice: 'left' | 'right';
  index: number;
  isCorrect: boolean;
  actual: 'left' | 'right';
}

export class Bisect extends Component<{
  Args: { start: string; end: string; debug: boolean };
  Blocks: {
    default: [data: { choices: Choice[]; color: Oklch; window: Window }];
  };
}> {
  @service('stops') declare stops: Stops;
  @service('router') declare router: RouterService;

  @link(Window) declare window: Window;

  choices: Choice[] = new TrackedArray();

  get currentColor() {
    const value = this.stops.searchSpace[this.window.current];

    assert(`[Bug]: no value for index: ${String(this.window.current)}`, value);

    return value;
  }

  get errors() {
    return this.choices.filter((choice) => !choice.isCorrect);
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
    const currentIndex = this.window.current;
    const currentColor = this.currentColor;

    const isLeft = currentIndex < middle;
    const isRight = currentIndex > middle;

    this.choices.push({
      color: currentColor,
      choice: chose,
      index: currentIndex,
      isCorrect: (chose === 'left' && isLeft) || (chose === 'right' && isRight),
      actual: isLeft ? 'left' : 'right',
    });

    console.log({
      isLeft,
      isRight,
    });
    this.window.debug();

    if (this.errors.length > 3) {
      console.debug(`Answered incorrectly 4 times. We're probably done.`);
      this.maybeFinish();
      return;
    }

    if (this.window.range < 3) {
      console.debug(`Window size is small. Not adding more colors`);
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
          this.window.anchorLeft();
          this.window.addStops();
          break;
        }
        // Incorrect
        if (isRight) {
          console.debug(
            `Color chosen *is not* more ${this.leftName}. Next colors will be closer to the left side (${this.leftName})`
          );
          this.window.slideLeft(this.window.askingRange / 2);
          this.window.addStops();
          break;
        }
        break;
      }
      case 'right': {
        // Incorrect
        if (isLeft) {
          console.debug(
            `Color chosen *is not* more ${this.rightName}. Next colors will be closer to the right side (${this.rightName})`
          );
          this.window.slideRight(this.window.askingRange / 2);
          this.window.addStops();
          break;
        }
        // Correct
        if (isRight) {
          console.debug(
            `Color chosen *is* more ${this.rightName}. Next colors will be closer to the middle`
          );
          // Get closer to center
          this.window.anchorRight();
          this.window.addStops();
          break;
        }
      }
    }

    const next = this.window.next();

    console.log(this.choices);
    if (next) {
      return;
    }

    this.maybeFinish();
  };

  maybeFinish() {
    if (this.window.queue.length === 0) {
      // We're done, calculate results
      this.finish();
      return;
    }
  }

  finish() {
    if (this.args.debug) {
      console.log(`in debug mode, we don't complete.`);
      return;
    }
    this.router.transitionTo('results', {
      queryParams: {
        choices: JSON.stringify(
          this.choices.map((choice) => {
            return {
              index: choice.index,
              isCorrect: choice.isCorrect,
              color: formatHex(choice.color),
            };
          })
        ),
      },
    });
  }

  <template>
    <Color class="color" @value={{this.currentColor}}>
      <Header>
        <button type="button" {{on "click" this.chooseLeft}}>More
          {{this.leftName}}</button>
        <span>|</span>
        <button type="button" {{on "click" this.chooseRight}}>More
          {{this.rightName}}</button>
      </Header>
    </Color>
    {{yield
      (hash choices=this.choices color=this.currentColor window=this.window)
    }}
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

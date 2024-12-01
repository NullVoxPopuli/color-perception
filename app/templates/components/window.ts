import { TrackedArray } from 'tracked-built-ins';
import {
  opposing,
  selectRandomBetween,
  selectRandomNonCenter,
} from 'color-perception/utils';
import { SEARCH_SIZE } from 'color-perception/services/stops';
import { cell } from 'ember-resources';

interface MoveOptions {
  include?: number[];
}

/**
 * We have a moving window of ranges to work with
 */
export class AmorphousWindow {
  // Decorators are broken. Same issue with @use elsewhere.
  // the descriptor is undefined.
  #current = cell(selectRandomNonCenter(0, SEARCH_SIZE));
  // Left-most boundary
  #left = cell(0);
  // Right-most boundary
  #right = cell(SEARCH_SIZE);
  get current() {
    return this.#current.current;
  }
  set current(value) {
    this.#current.set(value);
  }
  get left() {
    return this.#left.current;
  }
  set left(value) {
    this.#left.set(value);
  }
  get right() {
    return this.#right.current;
  }
  set right(value) {
    this.#right.set(value);
  }

  seen = new Set<number>([this.current]);
  queue = new TrackedArray([this.current]);

  get opposing() {
    return opposing(this.left, this.right, this.current);
  }

  debug() {
    console.debug({
      queue: [...this.queue],
      seen: [...this.seen.values()],
      left: this.left,
      right: this.right,
      current: this.current,
      opposing: this.opposing,
    });
  }

  get range() {
    return this.right - this.left;
  }

  get askingRange() {
    return Math.abs(this.opposing - this.current);
  }

  /**
   * TODO:
   * - don't shrink window passed an error
   * - don't expand a window passed a successful choice
   */
  next() {
    let first = this.queue.shift();

    while (first !== undefined && this.seen.has(first)) {
      first = this.queue.shift();
    }

    if (first) {
      this.current = first;
      this.seen.add(first);
    }

    return first;
  }

  addStops() {
    let stop = selectRandomBetween(this.left, this.right);

    while (this.seen.has(stop)) {
      stop = selectRandomBetween(this.left, this.right);
    }

    return this.queue.push(stop);
  }

  narrowInOn(index: number) {
    this.left = Math.max(index - 5, 0);
    this.right = Math.min(index + 5, SEARCH_SIZE);
  }

  anchorLeft(options?: MoveOptions) {
    const increment = Math.min(this.range / 100, 1);
    this.left = this.current;
    this.right -= Math.round(increment);

    if (this.range < 1) {
      this.right = this.left + 1;
    }

    if (options?.include) {
      this.include(options.include);
    }
  }
  anchorRight(options?: MoveOptions) {
    const increment = Math.min(this.range / 100, 1);
    this.right = this.current;
    this.left += Math.round(increment);

    if (this.range < 1) {
      this.right = this.left + 1;
    }

    if (options?.include) {
      this.include(options.include);
    }
  }

  slideLeft(amount: number, options?: MoveOptions) {
    this.left = Math.max(this.left - amount, 0);
    this.right = Math.max(this.right - amount, this.left);

    if (this.range < 1) {
      this.right = this.left + 1;
    }

    if (options?.include) {
      this.include(options.include);
    }
  }
  slideRight(amount: number, options?: MoveOptions) {
    this.right = Math.min(this.right + amount, SEARCH_SIZE);
    this.left = Math.min(this.left + amount, this.right);

    if (this.range < 1) {
      this.right = this.left + 1;
    }

    if (options?.include) {
      this.include(options.include);
    }
  }

  include(indicies: number[]) {
    const min = Math.min(...indicies);
    const max = Math.max(...indicies);

    if (min !== -Infinity /* empty */) {
      if (this.left > min) {
        this.left = min;
      }
    }

    if (max !== Infinity /* empty */) {
      if (this.right < max) {
        this.right = max;
      }
    }
  }
}

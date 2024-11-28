import { tracked } from '@glimmer/tracking';
import { TrackedArray } from 'tracked-built-ins';
import {
  opposing,
  selectRandomBetween,
  selectRandomNonCenter,
} from 'color-perception/utils';
import { SEARCH_SIZE } from 'color-perception/services/stops';

/**
 * We have a moving window of ranges to work with
 */
export class Window {
  @tracked current = selectRandomNonCenter(0, SEARCH_SIZE);
  // Left-most boundary
  @tracked left = 0;
  // Right-most boundary
  @tracked right = SEARCH_SIZE;

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
    const stop = selectRandomBetween(this.left, this.right);
    console.log({ stop });
    return this.queue.push(stop);
  }

  anchorLeft() {
    const increment = Math.min(this.range / 10, 1);
    this.left = this.current;
    this.right -= Math.round(increment);

    if (this.range < 1) {
      this.right = this.left + 1;
    }
  }
  anchorRight() {
    const increment = Math.min(this.range / 10, 1);
    this.right = this.current;
    this.left += Math.round(increment);

    if (this.range < 1) {
      this.right = this.left + 1;
    }
  }

  slideLeft(amount: number) {
    this.left = Math.max(this.left - amount, 0);
    this.right = Math.max(this.right - amount, this.left);

    if (this.range < 1) {
      this.right = this.left + 1;
    }
  }
  slideRight(amount: number) {
    this.right = Math.min(this.right + amount, SEARCH_SIZE);
    this.left = Math.min(this.left + amount, this.right);

    if (this.range < 1) {
      this.right = this.left + 1;
    }
  }
}

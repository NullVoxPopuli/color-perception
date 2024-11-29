import Component from '@glimmer/component';
import { assert } from '@ember/debug';
import { service } from '@ember/service';
import type Stops from 'color-perception/services/stops';
import { SEARCH_SIZE } from 'color-perception/services/stops';
import { Color } from './color';
import type { Oklch } from 'culori';

export class Choice extends Component<{
  Args: {
    choice: { index: number; isCorrect: boolean; color: string | Oklch };
  };
}> {
  @service declare stops: Stops;

  get position() {
    return (this.args.choice.index / SEARCH_SIZE) * 100;
  }

  get yPosition() {
    const height = document
      .querySelector('.results-overlay, .debug-overlay')
      ?.getBoundingClientRect().height;

    assert(
      `Cannot use <Choice> outside of a .results-overlay or .debug-overlay`,
      height
    );

    const top = 64;
    const bottom = 84 + top;
    const numerator = Math.random() * (height - bottom - top) + top;
    const denom = height - top;
    const percent = numerator / denom;

    return percent * 100;
  }

  <template>
    <div
      style="
        position: absolute;
        left: {{this.position}}%;
        top: {{this.yPosition}}%;
        transform: translateX(-50%);
      "
    >
      <Color @value={{@choice.color}}>{{if @choice.isCorrect "✅" "❌"}}</Color>
    </div>
  </template>
}

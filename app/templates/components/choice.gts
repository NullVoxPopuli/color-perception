import Component from '@glimmer/component';
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
    return Math.random() * window.innerHeight * 0.9;
  }

  <template>
    <div
      style="
        position: absolute;
        left: {{this.position}}%;
        top: {{this.yPosition}}px;
        transform: translateX(-50%);
      "
    >
      <Color @value={{@choice.color}}>{{if @choice.isCorrect "✅" "❌"}}</Color>
    </div>
  </template>
}

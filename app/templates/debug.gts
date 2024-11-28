import Route from 'ember-route-template';
import { differenceHueChroma } from 'culori';
import { pageTitle } from 'ember-page-title';
import { Bisect, type Choice as Chosen } from './components/bisect';
import { qp } from 'color-perception/utils';
import Component from '@glimmer/component';
import { Gradient } from './components/gradient';
import { Color } from './components/color';
import type Stops from 'color-perception/services/stops';
import { service } from '@ember/service';

export default Route(
  <template>
    {{pageTitle "Debug"}}

    <Gradient @start={{qp "start"}} @end={{qp "end"}}>
      <Bisect
        @start={{qp "start"}}
        @end={{qp "end"}}
        @debug={{true}}
        as |choices|
      >
        <div class="debug-overlay">
          {{#each choices as |choice|}}
            <Choice @choice={{choice}} />
          {{/each}}
        </div>
      </Bisect>
    </Gradient>

    <style>
      .debug-overlay {
        position: fixed;
        top: 40%;
        height: 300px;
        left: 0;
        right: 0;

        display: flex;
        gap: 1rem;

        .color {
          width: 3rem;
          height: 3rem;
          display: flex;
          align-items: center;
          justify-content: center;
          border: 1px solid;
        }
      }
      .color {
        width: 20%;
        height: 20%;
      }
    </style>
  </template>
);

class Choice extends Component<{ Args: { choice: Chosen } }> {
  @service declare stops: Stops;

  get position() {
    const value = differenceHueChroma(
      this.args.choice.color,
      this.stops.startOKLCH
    );

    return Math.abs(value * 100) / 0.6;
  }

  get yPosition() {
    return Math.random() * 200;
  }

  <template>
    <div
      style="
        position: absolute;
        left: {{this.position}}%;
        top: {{this.yPosition}}px;
      "
    >
      <Color @value={{@choice.color}}>{{@choice.isCorrect}}</Color>
    </div>
  </template>
}

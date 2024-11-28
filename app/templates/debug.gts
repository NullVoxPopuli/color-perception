import Route from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { Bisect } from './components/bisect';
import { qp } from 'color-perception/utils';
import Component from '@glimmer/component';
import { Gradient } from './components/gradient';
import { Choice } from './components/choice';
import type Stops from 'color-perception/services/stops';
import { service } from '@ember/service';
import { Window } from './components/window';
import { SEARCH_SIZE } from 'color-perception/services/stops';

export default Route(
  <template>
    {{pageTitle "Debug"}}

    <Gradient @start={{qp "start"}} @end={{qp "end"}}>
      <Bisect @start={{qp "start"}} @end={{qp "end"}} @debug={{true}} as |x|>
        <div class="debug-overlay">
          <Range @window={{x.window}} />
          {{#each x.choices as |choice|}}
            <Choice @choice={{choice}} />
          {{/each}}
        </div>
      </Bisect>
    </Gradient>

    <style>
      .debug-overlay {
        position: fixed;
        top: 200px;
        height: 300px;
        left: 0;
        right: 0;

        display: flex;
        gap: 1rem;

        .color {
          width: 3rem;
          height: 3rem;
          font-size: 2rem;
          text-shadow: 0px 1px 0px black;
          display: flex;
          align-items: center;
          justify-content: center;
          border: 1px solid;
        }

        .line.left {
          height: 100dvh;
          border-left: 1px solid;
        }
        .line.right {
          height: 100dvh;
          border-right: 1px solid;
          transform: translateX(-100%);
        }
      }
      .color {
        width: 200px;
        height: 200px;
        border: 1px solid;
      }
    </style>
  </template>
);

class Range extends Component<{ Args: { window: Window } }> {
  @service declare stops: Stops;

  get leftPosition() {
    const left = this.args.window.left;
    return (left / SEARCH_SIZE) * 100;
  }
  get rightPosition() {
    const right = this.args.window.right;
    return (right / SEARCH_SIZE) * 100;
  }

  <template>
    <div
      class="line left"
      style="position: absolute; left: {{this.leftPosition}}%;"
    >{{@window.left}}</div>
    <div
      class="line right"
      style="position: absolute; left: {{this.rightPosition}}%;"
    >{{@window.right}}</div>
  </template>
}

import Route from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { qp } from 'color-perception/utils';
import Component from '@glimmer/component';
import { Gradient } from './components/gradient';
import { Choice } from './components/choice';
import { use } from 'ember-resources';
import { Header } from './components/header';
import { LinkTo } from '@ember/routing';
import { nearestName } from './components/utils';
import type { TOC } from '@ember/component/template-only';

export default Route(
  <template>
    {{pageTitle "Results"}}

    <Gradient @start={{qp "start"}} @end={{qp "end"}}>
      <Choices />
      <Baseline />
      <LeftName @name={{nearestName (qp "start")}} />
      <RightName @name={{nearestName (qp "end")}} />

      <Header>
        <nav>
          <LinkTo @route="application">Back</LinkTo>
          <LinkTo @route="bisect">Try Again</LinkTo>
        </nav>
      </Header>
    </Gradient>
  </template>
);

const LeftName = <template>
  <span
    style="
    position: fixed;
    top: 0.5rem;
    left: 0.5rem;
    color: white;
    mix-blend-mode: difference;
    "
  >{{@name}}</span>
</template> satisfies TOC<{ Args: { name: string } }>;
const RightName = <template>
  <span
    style="
    position: fixed;
    top: 0.5rem;
    right: 0.5rem;
    color: white;
    mix-blend-mode: difference;
    "
  >{{@name}}</span>
</template> satisfies TOC<{ Args: { name: string } }>;

const Baseline = <template>
  <div
    style="
    position: absolute;
    padding-left: 0.5rem;
    left: 50%;
    border-left: 1px solid white;
    transform: translateX(-50%);
    color: white;
    mix-blend-mode: luminocity;
    top: 0;
    bottom: 0;
    z-index: 1;
    "
  >Baseline</div>
</template>;

type QPChoice = [
  index: number,
  isCorrect: 1 | 0,
  choice: 0 | 1,
  actual: 0 | 1,
  hex: string,
];

export class Choices extends Component {
  #choices = use(this, qp('choices'));

  get choices() {
    const parsed = JSON.parse(this.#choices.current) as QPChoice[];
    const result = parsed.map(([index, isCorrect, choice, actual, hex]) => ({
      index,
      color: hex,
      isCorrect: isCorrect === 1,
      choice,
      actual,
    }));

    return result;
  }

  <template>
    <div class="results-overlay">
      {{#each this.choices as |choice|}}
        <Choice @choice={{choice}} />
      {{/each}}
    </div>
  </template>
}

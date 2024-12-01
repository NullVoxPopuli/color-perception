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
import {
  Baseline,
  LeftName,
  RightName,
  YourMiddle,
} from './components/results';

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
      <YourMiddle @choices={{this.choices}} />
      {{#each this.choices as |choice|}}
        <Choice @choice={{choice}} />
      {{/each}}
    </div>
  </template>
}

import Route from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { qp } from 'color-perception/utils';
import Component from '@glimmer/component';
import { Gradient } from './components/gradient';
import { Choice } from './components/choice';
import { use } from 'ember-resources';
import { Header } from './components/header';
import { LinkTo } from '@ember/routing';

interface QPChoice {
  isCorrect: boolean;
  index: number;
  color: string;
}

export default Route(
  <template>
    {{pageTitle "Debug"}}

    <Gradient @start={{qp "start"}} @end={{qp "end"}}>
      <Choices />

      <Header>
        <nav>
          <LinkTo @route="application">Back</LinkTo>
          <LinkTo @route="bisect">Try Again</LinkTo>
        </nav>
      </Header>
    </Gradient>
  </template>
);

export class Choices extends Component {
  #choices = use(this, qp('choices'));

  get choices(): QPChoice[] {
    return JSON.parse(this.#choices.current) as QPChoice[];
  }

  <template>
    <div class="results-overlay">
      {{#each this.choices as |choice|}}
        <Choice @choice={{choice}} />
      {{/each}}
    </div>
  </template>
}

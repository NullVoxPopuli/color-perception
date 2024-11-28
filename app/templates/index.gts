import Route from 'ember-route-template';
import { Gradient } from './components/gradient';
import { nearestName } from './components/utils';
import { Header } from './components/header';
import { LinkTo } from '@ember/routing';
import { qp } from 'color-perception/utils';

export default Route(
  <template>
    <Gradient @start={{qp "start"}} @end={{qp "end"}}>

      {{#let (nearestName (qp "start")) as |name|}}
        <h1>Is my "{{name}}" your "{{name}}"?</h1>
      {{/let}}
      <div class="wrapper">

        <Header>
          <nav>
            <LinkTo @route="configure">Change Colors</LinkTo>
            <LinkTo @route="bisect">Begin Test</LinkTo>
          </nav>
        </Header>
      </div>
    </Gradient>

    <style>
      .wrapper {
        position: fixed;
        inset: 0;
        z-index: 1;
        height: 100dvh;
        width: 100dvw;
      }
      h1 {
        padding: 1rem;
        z-index: 2;
        margin: 0 auto;
        font-size: 3rem;
        filter: invert(1) drop-shadow(0px 3px 4px rgba(0, 0, 0, 0.75));
        /* mix-blend-mode: color-burn; */
        align-self: center;
      }
    </style>
  </template>
);

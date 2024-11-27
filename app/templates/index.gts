import Route from 'ember-route-template';
import { Gradient } from './components/gradient';
import { qp } from './components/qp';
import { defaultEnd, defaultStart, nearestName } from './components/utils';
import { Header } from './components/header';

export default Route(
  <template>
    <Gradient @start={{qp "start" defaultStart}} @end={{qp "end" defaultEnd}}>

      {{#let (nearestName (qp "start" defaultStart)) as |name|}}
        <h1>Is my {{name}} your {{name}}?</h1>
      {{/let}}
      <div class="wrapper">

        <Header>
          <nav>
            <a href="/configure">Change Colors</a>
            <a href="/bisect">Begin Test</a>
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

import Route from 'ember-route-template';
import { Gradient } from './components/gradient';
import { nearestName } from './components/utils';
import { Header } from './components/header';
import { LinkTo } from '@ember/routing';
import { qp } from 'color-perception/utils';
import { ExternalLink } from 'ember-primitives/components/external-link';

export default Route(
  <template>
    <Gradient @start={{qp "start"}} @end={{qp "end"}}>

      {{#let (nearestName (qp "start")) as |name|}}
        <h1><span>Is my
            <span class="title-color-name">{{name}}</span></span><br />
          <span class="indented">your
            <span class="title-color-name">{{name}}</span><span
              class="title-question"
            >?</span></span></h1>
      {{/let}}
      <div class="wrapper">
        <nav aria-label="secondary nav">
          <LinkTo class="debug" @route="debug">debug</LinkTo>
          <ExternalLink
            href="https://github.com/NullVoxPopuli/color-perception"
            class="github"
          >GitHub</ExternalLink>
        </nav>

        <Header>
          <nav aria-label="main nav">
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
      nav#nav-info {
        position: fixed;
        top: 0.5rem;
        left: 0.5rem;
        display: flex;
        gap: 0.75rem;
        a {
          font-size: 0.8rem;
          color: white;
          mix-blend-mode: difference;
        }
      }
      h1 {
        padding: 1rem;
        z-index: 2;
        margin: 0 auto;
        text-align: center;
        font-size: 3rem;
        font-size: calc(100% + 3dvw);
        filter: invert(1) drop-shadow(0px 2px 0px rgba(0, 0, 0, 0.75));
        /* mix-blend-mode: color-burn; */
        align-self: center;

        .title-color-name {
          display: inline-block;
          text-decoration: underline;
        }
        .title-question {
          display: inline-block;
          font-size: calc(100% + 3.2dvw);
          transform: rotateZ(10deg);
        }
      }
      @media only screen and (min-width: 600px) {
        h1 .indented {
          padding-left: 8rem;
        }
      }
    </style>
  </template>
);

import Route from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import Component from '@glimmer/component';
import { service } from '@ember/service';
import { Gradient } from './components/gradient';
import { Form as WrappedForm } from 'ember-primitives/components/form';
import type RouterService from '@ember/routing/router-service';
import { Header } from './components/header';
import { LinkTo } from '@ember/routing';
import { Stops } from './components/stops';
import { appValue, qp } from 'color-perception/utils';

export default Route(
  <template>
    {{pageTitle "Configure"}}

    <Gradient @start={{qp "start"}} @end={{qp "end"}}>
      <Form />

      <Stops class="stops" @stops={{appValue "stops" "previewSamples"}} />

      <Header>
        <nav>
          <LinkTo @route="application">Back</LinkTo>
        </nav>
      </Header>
    </Gradient>

    <style>
      .stops {
        position: absolute;
        left: 0;
        right: 0;
        top: 0;
        bottom: 0;
        z-index: 1;
      }
      form {
        z-index: 2;
        align-self: center;
        justify-self: center;
        margin: 0 auto;
        background: white;
        border: 1px solid;
        border-radius: 0.25rem;
        padding: 1.5rem;
        display: flex;
        gap: 3rem;

        label {
          display: flex;
          flex-direction: row;
          justify-content: space-between;
          align-items: center;
          gap: 1rem;
        }
      }
    </style>
  </template>
);

class Form extends Component {
  @service declare router: RouterService;

  update = (data: unknown) => {
    const { left, right } = data as { left: string; right: string };

    this.router.transitionTo({
      queryParams: {
        start: left,
        end: right,
      },
    });
  };

  <template>
    <WrappedForm @onChange={{this.update}}>
      <label>
        Left Color
        <input type="color" name="left" value={{qp "start"}} />
      </label>
      <br />
      <label>
        Right Color
        <input type="color" name="right" value={{qp "end"}} />
      </label>
    </WrappedForm>
  </template>
}

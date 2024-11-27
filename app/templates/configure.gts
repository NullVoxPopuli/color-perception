import Route from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import Component from '@glimmer/component';
import { service } from '@ember/service';
import { Gradient } from './components/gradient';
import { qp } from './components/qp';
import { defaultEnd, defaultStart } from './components/utils';
import { Form as WrappedForm } from 'ember-primitives/components/form';
import type RouterService from '@ember/routing/router-service';
import { Header } from './components/header';

export default Route(
  <template>
    {{pageTitle "Configure"}}

    <Gradient @start={{qp "start" defaultStart}} @end={{qp "end" defaultEnd}}>
      <Form />

      <Header>
        <nav>
          <a href="/">Back</a>
        </nav>
      </Header>
    </Gradient>

    <style>
      form {
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
        <input type="color" name="left" value={{qp "start" defaultStart}} />
      </label>
      <br />
      <label>
        Right Color
        <input type="color" name="right" value={{qp "end" defaultEnd}} />
      </label>
    </WrappedForm>
  </template>
}

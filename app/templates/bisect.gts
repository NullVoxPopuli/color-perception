import Route from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { Bisect } from './components/bisect';
import { qp } from 'color-perception/utils';

export default Route(
  <template>
    {{pageTitle "Bisect"}}

    <Bisect @start={{qp "start"}} @end={{qp "end"}} />
  </template>
);

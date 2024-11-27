import Route from 'ember-route-template';
import { qp } from './components/qp';
import { pageTitle } from 'ember-page-title';
import { Bisect } from './components/bisect';

const defaultStart = '#ff0000';
const defaultEnd = '#ff00ff';

export default Route(
  <template>
    {{pageTitle "Bisect"}}

    <Bisect @start={{qp "start" defaultStart}} @end={{qp "end" defaultEnd}} />
  </template>
);

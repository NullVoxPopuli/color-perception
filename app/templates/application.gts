import Route from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { Gradient } from './components/gradient';
import { qp } from './components/qp';

const defaultStart = '#ff0000';
const defaultEnd = '#ff00ff';

export default Route(
  <template>
    {{pageTitle "Color Perception"}}

    {{outlet}}

    <Gradient @start={{qp "start" defaultStart}} @end={{qp "end" defaultEnd}} />
  </template>
);

import Route from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { qp } from './qp';

const defaultStart = '#ff0000';
const defaultEnd = '#ff00ff';

export default Route(
  <template>
    {{pageTitle "Color Perception"}}

    {{outlet}}

    <div
      class="gradient"
      style="
        --start: {{qp 'start' defaultStart}};
        --end: {{qp 'end' defaultEnd}};
      "
    ></div>

    <style>
      .gradient {
        height: 100dvh;
        width: 100dvw;
        background-image: linear-gradient(
          in oklch to right,
          var(--start),
          var(--end)
        );
      }
    </style>
  </template>
);

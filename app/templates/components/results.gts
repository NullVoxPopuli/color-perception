import type { TOC } from '@ember/component/template-only';
import { SEARCH_SIZE } from 'color-perception/services/stops';
import { qp } from 'color-perception/utils';
import { nearestName } from './utils';

export const Baseline = <template>
  <div
    style="
    position: absolute;
    padding-left: 0.5rem;
    left: 50%;
    border-left: 2px dotted white;
    transform: translateX(-50%);
    color: rgba(255, 255, 255, 0.7);
    mix-blend-mode: luminocity;
    top: 0;
    bottom: 0;
    z-index: 1;
    "
  ><span
      style="position: absolute;transform: translateX(-50%); width: max-content;"
    >Baseline middle</span></div>
</template>;

export const LeftName = <template>
  <span
    style="
    position: absolute;
    top: 0.5rem;
    left: 0.5rem;
    color: white;
    mix-blend-mode: difference;
    "
  >{{@name}}</span>
</template> satisfies TOC<{ Args: { name: string } }>;

export const RightName = <template>
  <span
    style="
    position: absolute;
    top: 0.5rem;
    right: 0.5rem;
    color: white;
    mix-blend-mode: difference;
    "
  >{{@name}}</span>
</template> satisfies TOC<{ Args: { name: string } }>;

function errorOffset(choices: { isCorrect: boolean; index: number }[]) {
  const errors = choices.filter((choice) => !choice.isCorrect);

  let sum = 0;
  errors.forEach((error) => (sum += error.index));
  const avg = sum / errors.length;

  if (Number.isNaN(avg)) {
    // half way
    return 50;
  }
  return (avg / SEARCH_SIZE) * 100;
}

export const YourMiddle = <template>
  <span class="your-line the-line" style="left: {{errorOffset @choices}}%;">
    <span class="diamond"></span>
  </span>
  <div class="your-line labels" style="left: {{errorOffset @choices}}%;">
    <span class="label-container">
      <span class="you-call-start">You call this
        {{nearestName (qp "start")}}</span>
      <span class="you-call-end">You call this {{nearestName (qp "end")}}</span>
    </span>
  </div>
  <style>
    .your-line {
      position: absolute;
      transform: translateX(-50%);
      color: white;
      mix-blend-mode: luminosity;
      top: 0;
      bottom: 0;
      z-index: 1;
      display: flex;
      align-items: end;
      justify-content: center;
      pointer-events: none;

      &.the-line {
        background: white;
        width: 2px;
      }

      &.labels {
        bottom: 0.5rem;
      }

      &.the-line,
      .you-call-end,
      .you-call-start {
        filter: drop-shadow(0px 0px 1px rgba(0, 0, 0, 0.5));
      }

      .diamond {
        display: block;
        padding: 1rem;
        width: 4rem;
        margin-bottom: 0.5rem;
        text-align: center;
        background: white;
        transform: rotate(45deg);
        aspect-ratio: 1;
        font-size: 2rem;
        color: black;
        z-index: 1;
      }

      .label-container {
        display: grid;
        grid-auto-flow: column;
        grid-auto-columns: 1fr 1fr;
        align-items: center;
        gap: 4rem;
        max-width: 100dvw;

        .you-call-end,
        .you-call-start {
          font-size: 1.5rem;
          width: max-content;
          font-weight: bold;
          z-index: 2;
          max-width: 35dvw;
        }
        .you-call-start {
          text-align: right;
          justify-self: end;
        }
        .you-call-end {
          text-align: left;
          justify-self: start;
        }
      }
    }
    .color-result-indicator {
      position: relative;
      font-size: 1rem;
    }
  </style>
</template> satisfies TOC<{
  Args: { choices: { isCorrect: boolean; index: number }[] };
}>;

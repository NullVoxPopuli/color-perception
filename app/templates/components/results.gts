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
    color: white;
    mix-blend-mode: luminocity;
    top: 0;
    bottom: 0;
    z-index: 1;
    "
  ><span style="position: absolute;">Baseline middle</span></div>
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
  <div class="your-line" style="left: {{errorOffset @choices}}%;"><span
      class="the-line"
    ></span><span class="label-container">
      <span class="you-call-start">You call this
        {{nearestName (qp "start")}}</span>
      <span class="label"></span>
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

      .label-container {
        display: grid;
        grid-auto-flow: column;
        grid-auto-columns: 2fr 1fr 2fr;
        align-items: center;
        gap: minmax(calc(100dvw / 100 + 1), 3rem);

        .you-call-end,
        .you-call-start {
          font-size: 1.5rem;
          width: max-content;
          text-shadow: 0 0px 3px black;
          font-weight: bold;
          z-index: 2;
        }
        .you-call-start {
          text-align: right;
          justify-self: end;
        }
        .you-call-end {
          text-align: left;
          justify-self: start;
        }
        .label {
          display: block;
          padding: 1rem;
          text-align: center;
          background: white;
          transform: rotate(45deg);
          aspect-ratio: 1;
          font-size: 2rem;
          color: black;
          z-index: 1;
        }
      }
      .the-line {
        background: white;
        width: 1px;
        height: 100%;
        position: absolute;
        top: 0;
        bottom: 0;
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

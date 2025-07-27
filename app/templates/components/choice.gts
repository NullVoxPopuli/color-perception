import Component from '@glimmer/component';
import { assert } from '@ember/debug';
import { service } from '@ember/service';
import type Stops from 'color-perception/services/stops';
import { SEARCH_SIZE } from 'color-perception/services/stops';
import { Color } from './color';
import type { Oklch } from 'culori';
import { nearestName } from './utils';
import { ExternalLink } from 'ember-primitives/components/external-link';
import type { TOC } from '@ember/component/template-only';
import { FloatingUI } from 'ember-primitives/floating-ui';
import {
  colorFor,
  hexRGBToOklch,
  round100,
  round1000,
} from 'color-perception/utils';

function isLeft(x: 0 | 1 | 'left' | 'right') {
  return x === 0 || x === 'left';
}

export class Choice extends Component<{
  Args: {
    choice: {
      index: number;
      isCorrect: boolean;
      color: string | Oklch;
      choice: 0 | 1 | 'left' | 'right';
      actual: 0 | 1 | 'left' | 'right';
    };
  };
}> {
  @service declare stops: Stops;

  get position() {
    return (this.args.choice.index / SEARCH_SIZE) * 100;
  }

  get yPosition() {
    const height = document
      .querySelector('.results-overlay, .debug-overlay')
      ?.getBoundingClientRect().height;

    assert(
      `Cannot use <Choice> outside of a .results-overlay or .debug-overlay`,
      height
    );

    const top = 64;
    const nav = 84;
    const gutter = 200;
    const bottom = nav + gutter + top;
    const numerator = Math.random() * (height - bottom - top) + top;
    const denom = height - top;
    const percent = numerator / denom;

    return percent * 100;
  }

  get startName() {
    return nearestName(this.stops.start);
  }
  get endName() {
    return nearestName(this.stops.end);
  }

  get symbol() {
    return this.args.choice.isCorrect ? '✅' : '❌';
  }

  get popoverId() {
    return `floating-${colorFor(this.args.choice.color).replace('#', '')}`;
  }

  <template>
    <div
      class="choice-wrapper"
      style="
        left: {{this.position}}%;
        top: {{this.yPosition}}%;
      "
    >

      <FloatingUI as |reference floating|>
        <button popovertarget={{this.popoverId}} type="button" {{reference}}>
          <Color @value={{@choice.color}}>{{this.symbol}}</Color>
        </button>

        <menu {{floating}} popover id={{this.popoverId}}>
          {{#if @choice.isCorrect}}
            <p>You correctly identified this color,
              <ColorLink @color={{@choice.color}} />, as
              {{if (isLeft @choice.actual) this.startName this.endName}}.
            </p>
          {{else}}
            <p>You said
              <ColorLink @color={{@choice.color}} />
              was more
              {{if (isLeft @choice.choice) this.startName this.endName}}, but
              number-wise, in
              <ExternalLink
                href="https://oklch.com/{{maybeOklch @choice.color}}"
              >oklch</ExternalLink>
              space, this color is more
              {{if (isLeft @choice.actual) this.startName this.endName}}.
            </p>
          {{/if}}

        </menu>
      </FloatingUI>
    </div>
  </template>
}

function maybeOklch(color: string | Oklch) {
  let oklch: Oklch;

  if (typeof color === 'string') {
    if (color.startsWith('#')) {
      oklch = hexRGBToOklch(color);
    }
  }

  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
   
  if (!oklch) {
    console.warn(
      // eslint-disable-next-line @typescript-eslint/ban-ts-comment
      // @ts-ignore
      // eslint-disable-next-line @typescript-eslint/no-base-to-string
      `WARNING: ${String(color)} could not be converted to lch for link`
    );
    return color;
  }

  // The oklch site here uses a different unit for L
  return `#${round100(oklch.l * 100)},${round1000(oklch.c)},${round100(
    oklch.h || 0
  )},100`;
}

const ColorLink = <template>
  <ExternalLink href="https://oklch.com/{{maybeOklch @color}}">{{colorFor
      @color
    }}</ExternalLink>
</template> satisfies TOC<{
  Args: {
    color: string | Oklch;
  };
}>;

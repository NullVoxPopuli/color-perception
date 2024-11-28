import type { TOC } from '@ember/component/template-only';
import type { Oklch } from 'culori';

export const Stops = <template>
  <div ...attributes class="marker-wrapper">
    {{#each @stops as |stop|}}
      <div
        class="marker"
        style="
            --l: {{stop.l}};
            --c: {{stop.c}};
            --h: {{stop.h}}deg;
          "
      ></div>
    {{/each}}
  </div>
  <style>
    .marker-wrapper {
      display: grid;
      justify-content: space-between;
      grid-auto-flow: column;
    }
    .marker {
      width: 2rem;
      height: 100%;
      --lch: var(--l) var(--c) var(--h);
      background-color: oklch(var(--lch));
      border-left: 1px solid lch(calc(var(--l) * 0.15) var(--c) var(--h));
      border-right: 1px solid lch(calc(var(--l) * 0.15) var(--c) var(--h));
    }
  </style>
</template> satisfies TOC<{
  Element: HTMLDivElement;
  Args: {
    stops: Array<Oklch>;
  };
}>;

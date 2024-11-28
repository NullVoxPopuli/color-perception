import type { TOC } from '@ember/component/template-only';
import type { Oklch } from 'culori';

export const Color = <template>
  <div
    ...attributes
    class="color"
    style="
      --l: {{@value.l}};
      --c: {{@value.c}};
      --h: {{@value.h}}deg;
    "
  >{{yield}}</div>

  <style>
    .color {
      --lch: var(--l) var(--c) var(--h);
      background-color: oklch(var(--lch));
    }
  </style>
</template> satisfies TOC<{
  Element: HTMLDivElement;
  Args: {
    value: Oklch;
  };
  Blocks: {
    default: [];
  };
}>;

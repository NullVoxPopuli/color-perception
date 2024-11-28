import type { TOC } from '@ember/component/template-only';
import type { Oklch } from 'culori';

export const Color = <template>
  <div
    class="color"
    style="
      --l: {{@value.l}};
      --c: {{@value.c}};
      --h: {{@value.h}}deg;
    "
  ></div>

  <style>
    .color {
      height: 100dvh;
      width: 100dvw;
      --lch: var(--l) var(--c) var(--h);
      background-color: oklch(var(--lch));
    }
  </style>
</template> satisfies TOC<{
  Args: {
    value: Oklch;
  };
}>;

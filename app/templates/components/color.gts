import type { TOC } from '@ember/component/template-only';
import type { Oklch } from 'culori';

function colorFor(value: string | Oklch) {
  if (typeof value === 'string') {
    return value;
  }

  return `oklch(${String(value.l)} ${String(value.c)} ${String(value.h)}deg)`;
}

export const Color = <template>
  <div
    ...attributes
    class="color"
    style="background-color: {{colorFor @value}};"
  >{{yield}}</div>
</template> satisfies TOC<{
  Element: HTMLDivElement;
  Args: {
    value: Oklch | string;
  };
  Blocks: {
    default: [];
  };
}>;

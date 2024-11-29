import type { TOC } from '@ember/component/template-only';
import { colorFor } from 'color-perception/utils';
import type { Oklch } from 'culori';

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

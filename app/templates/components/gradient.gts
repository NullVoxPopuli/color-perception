import type { TOC } from '@ember/component/template-only';

export const Gradient = <template>
  <div
    ...attributes
    class="gradient"
    style="
        --start: {{@start}};
        --end: {{@end}};
      "
  >{{yield}}</div>

  <style>
    .gradient {
      display: flex;
      height: 100dvh;
      width: 100dvw;
      background-image: linear-gradient(
        in oklch to right,
        var(--start),
        var(--end)
      );
    }
  </style>
</template> satisfies TOC<{
  Element: HTMLDivElement;
  Args: {
    start: string;
    end: string;
  };
  Blocks: { default: [] };
}>;

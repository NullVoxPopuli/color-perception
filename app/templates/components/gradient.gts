import type { TOC } from '@ember/component/template-only';

export const Gradient = <template>
  <div
    class="gradient"
    style="
        --start: {{@start}};
        --end: {{@end}};
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
</template> satisfies TOC<{
  Args: {
    start: string;
    end: string;
  };
}>;

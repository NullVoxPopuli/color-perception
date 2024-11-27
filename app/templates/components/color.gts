import type { TOC } from '@ember/component/template-only';

export const Color = <template>
  <div class="color" style="--value: {{@value}};"></div>

  <style>
    .color {
      height: 100dvh;
      width: 100dvw;
      background-color: oklch(var(--value));
    }
  </style>
</template> satisfies TOC<{
  Args: {
    value: string;
  };
}>;

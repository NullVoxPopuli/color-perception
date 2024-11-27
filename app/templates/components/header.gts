import type { TOC } from '@ember/component/template-only';

export const Header = <template>
  <header>
    {{yield}}
  </header>
  <style>
    header {
      z-index: 10;
      position: absolute;
      bottom: 0;
      background: black;
      color: white;
      padding: 0.5rem 1rem;
      width: 100%;

      nav {
        display: flex;
        gap: 3rem;
        justify-content: space-between;
      }
      a {
        color: white;
        font-size: 3rem;
      }
    }
  </style>
</template> satisfies TOC<{ Blocks: { default: [] } }>;

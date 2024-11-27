import Component from '@glimmer/component';
import { Color } from './color';

export class Bisect extends Component<{
  Args: { start: string; end: string };
}> {
  choices = {};
  <template><Color @value="50% 0.4 20deg" /></template>
}

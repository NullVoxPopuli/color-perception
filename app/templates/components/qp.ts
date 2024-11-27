import { resource, resourceFactory } from 'ember-resources';
import { assert } from '@ember/debug';

// const defaultStart = '#ff0000';
// const defaultEnd = '#ff00ff';
const defaultStart = '#00ff00';
const defaultEnd = '#0000ff';

const defaults = {
  start: defaultStart,
  end: defaultEnd,
} as Record<string, string>;

export function qp(name: string) {
  return resource(({ owner }) => {
    const router = owner.lookup('service:router');
    const qpValue = router.currentRoute?.queryParams[name];

    assert(
      `expected qp to do be a string (or falsey). what witchcraft did you do?!?!`,
      typeof qpValue === 'string' || !qpValue
    );

    // eslint-disable-next-line @typescript-eslint/no-base-to-string
    return (qpValue ? String(qpValue) : defaults[name]) || '';
  });
}

// Needed until ember natively supports resources
resourceFactory(qp);

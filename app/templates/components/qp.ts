import { resource, resourceFactory } from 'ember-resources';
import { assert } from '@ember/debug';

export function qp(name: string, defaultValue?: string) {
  return resource(({ owner }) => {
    const router = owner.lookup('service:router');
    const qpValue = router.currentRoute?.queryParams[name];

    assert(
      `expected qp to do be a string (or falsey). what witchcraft did you do?!?!`,
      typeof qpValue === 'string' || !qpValue
    );

    // eslint-disable-next-line @typescript-eslint/no-base-to-string
    return (qpValue ? String(qpValue) : defaultValue) || '';
  });
}

// Needed until ember natively supports resources
resourceFactory(qp);

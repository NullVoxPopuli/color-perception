import { resource, resourceFactory } from 'ember-resources';

export function qp(name: string, defaultValue?: string) {
  return resource(({ owner }) => {
    const router = owner.lookup('service:router');
    const qpValue = router.currentRoute?.queryParams[name];

    return String(qpValue) || defaultValue || '';
  });
}

// Needed until ember natively supports resources
resourceFactory(qp);

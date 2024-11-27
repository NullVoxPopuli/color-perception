import { resource, resourceFactory } from 'ember-resources';

export function qp(name: string, defaultValue?: string) {
  return resource(({ owner }) => {
    const router = owner.lookup('service:router');

    return router.currentRoute?.queryParams[name] ?? defaultValue;
  });
}

// Needed until ember natively supports resources
resourceFactory(qp);

import Route from '@ember/routing/route';

export default class Application extends Route {
  queryParams = {
    start: { refreshModel: false },
    end: { refreshModel: false },
  };
}

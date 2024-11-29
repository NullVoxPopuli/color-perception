import Route from '@ember/routing/route';

export default class Results extends Route {
  queryParams = {
    choices: { refreshModel: false },
  };
}

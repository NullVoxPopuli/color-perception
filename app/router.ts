import EmberRouter from '@ember/routing/router';
import config from 'color-perception/config/environment';

import { properLinks } from 'ember-primitives/proper-links';

@properLinks
export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  this.route('bisect');
  this.route('configure');
});

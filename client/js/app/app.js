
this.app = angular.module('drone', ["utils"], function($routeProvider, $locationProvider) {

  $routeProvider.when('/basic', {
    templateUrl: 'interface/basic',
    controller: BasicController
  });

  $routeProvider.otherwise({
    redirectTo: '/basic'
  });
});

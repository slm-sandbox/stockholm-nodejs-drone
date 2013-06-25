
this.app = angular.module('drone', ["utils"], function($routeProvider, $locationProvider) {

  $routeProvider.when('/basic', {
    templateUrl: 'interface/basic',
    controller: BasicController
  });

  $routeProvider.when('/sandbox', {
    templateUrl: 'interface/sandbox',
    controller: SandboxController
  });

  $routeProvider.otherwise({
    redirectTo: '/basic'
  });
});

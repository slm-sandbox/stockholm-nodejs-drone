
this.app = angular.module('drone', ["utils"], function($routeProvider, $locationProvider) {

  $routeProvider.when('/basic', {
    templateUrl: 'interface/basic',
    controller: BasicController
  });

  $routeProvider.when('/sandbox', {
    templateUrl: 'interface/sandbox',
    controller: SandboxController
  });

  $routeProvider.when('/video', {
    templateUrl: 'interface/video',
    controller: VideoController
  });

  $routeProvider.otherwise({
    redirectTo: '/basic'
  });
});

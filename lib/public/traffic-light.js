/* App Module */
var trafficLightApp = angular.module('trafficLightApp', [
		'trafficLightControllers',
		'trafficLightServices'
		]);

/* Services */
var trafficLightServices = angular.module('trafficLightServices', ['ngResource']);

trafficLightServices.factory('TrafficLight', ['$resource',
		function($resource){
			'use strict';
			return $resource('/:lineId/:lightId/:stateId', null,
				{
					'set': { method: 'POST', params: {lineId: '@lineId', lightId: '@lightId', stateId: '@stateId'}},
					'query': { method: 'GET', url: '/lines' },
				});
		}]);

/* Controllers */
var trafficLightControllers = angular.module('trafficLightControllers', []);

trafficLightControllers.controller('trafficLightCtrl', ['$scope', 'TrafficLight',
		function($scope, TrafficLight) {
			'use strict';
			$scope.trafficlights = TrafficLight.query();

			$scope.switchLight = function(line, light, state) {
				if (state === 0) {
					state = 1;
				} else {
					state = 0;
				}
				TrafficLight.set({lineId: line, lightId: light, stateId: state});
				$scope.trafficlights = TrafficLight.query();
			};
		}]);

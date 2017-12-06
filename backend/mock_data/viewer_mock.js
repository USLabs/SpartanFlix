/**
 * Mock data for viewer
 * @type {{}}
 */
const VIEWER_MOCK = {
	signupRequest: {
		"id": 0,
		"email": "user@testdomain.com",
		"firstName": "Daniel",
		"lastName": "Lewis",
		"password": "123",
		"startDate": "YYYY-MM-DD",
		"mainSubscriberId": 0,
		"subscriptionId": 1
	},
	signupResponse: {
		"id": 0,
		"email": "user@testdomain.com",
		"firstName": "Daniel",
		"lastName": "Lewis",
		"startDate": "YYYY-MM-DD",
		"mainSubscriberId": 0,
		"subscriptionId": 1,
		"subscriptionList": [
			{
				"id": 0,
				"price": 9.99,
				"duration": 30, // days,
				"hasAd": true
			},
			{
				"id": 1,
				"price": 10.99,
				"duration": 30, //days
				"hasAd": true
			},
			{
				"id": 2,
				"price": 12.99,
				"duration": 30, // days,
				"hasAd": false
			}
		]
	},
	loginRequest: {
		"email": "string",
		"password": "string"
	},
	loginResponse: {
		"id": 0,
		"email": "user@testdomain.com",
		"firstName": "Daniel",
		"lastName": "Lewis",
		"startDate": "YYYY-MM-DD",
		"mainSubscriberId": 0,
		"subscriptionId": 1,
		"contentList": [
			{
				"contentId": 0,
				"title": "title 1",
				"director": "director 1",
				"contentProviderName": "content provider 1",
				"contentType": "movie",
				"cast": [
					{
						"name": "actor 1"
					},
					{
						"name": "actress 1"
					}
				]
			},
			{
				"contentId": 1,
				"title": "title 2",
				"director": "director 2",
				"contentProviderName": "content provider 2",
				"contentType": "movie",
				"cast": [
					{
						"name": "actor 2"
					},
					{
						"name": "actress 2"
					}
				]
			}
		]
	},
	defaultResponse: {
		"message" : "Default response from ViewerRouter"
	}
};

// type: object
// properties:
// 	contentId:
// 		type: integer
// title:
// 	type: string
// director:
// 	type: string
// contentProviderId:
// 	type: integer
// cast:
// 	type: array
// items:
// 	$ref: '#/definitions/Actor'
// contentType:
// 	type: string

module.exports = VIEWER_MOCK;

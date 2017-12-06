$(document).ready(function()
{
	var $viewercontent;
	$('#viewer_login').click(function(event) {

		event.preventDefault();

		var $email = $('#viewer_email');

		var $password= $('#viewer_password');

		var postData = {

		 	email: $email.val(),
		 	password: $password.val()

		 };

		url = "http://52.52.157.178:3000/viewer/login";
		var jqxhr = $.ajax(
			{
				method: "POST",
				datatype : "json",
				url: url,
				data: postData
			}
			)
			.done(function(data) {
				//window.location.href ='../production/index.html'; 

var userData = {
 storeUserDataInSession: function(userData) {
     var userObjectString = JSON.stringify(userData);
     window.sessionStorage.setItem('userObject',userObjectString)
 },
 getUserDataFromSession: function() {
     var userData = window.sessionStorage.getItem('userObject')
     return JSON.parse(userData);
 }
}
userData.storeUserDataInSession(data);
				
				window.location.href="../production/index.html";


						//$viewercontent=data;

				console.log(data);
			})
			.fail(function(error) {
				console.log("error");
			});


	});

});
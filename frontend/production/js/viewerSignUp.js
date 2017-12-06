$(document).ready(function()
{
	var $viewercontent;
	$('#viewer_signup').click(function(event) {

		event.preventDefault();

		var $fname = $('#viewer_fname');

		var $lname = $('#viewer_lname');

		var $email = $('#viewer_email');

		var $password= $('#viewer_password');

		var postData = {
			firstName: $fname.val(),
			lastName: $lname.val(),
    
   			mainsubscriptionId: 1,
   			subscriptionId: 1,
 
   			startDate: "2017-01-01 09-10-10",
		 	email: $email.val(),
		 	password: $password.val()

		 };

		url = "http://52.52.157.178:3000/viewer/signup";
		var jqxhr = $.ajax(
			{
				method: "POST",
				datatype : "json",
				url: url,
				data: postData
			}
			)
			.done(function(data) {
			
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
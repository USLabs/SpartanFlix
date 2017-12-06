$(document).ready(function()
{
	$('#signup').click(function() {

		var $viewerval = $('#bio');

		$.ajax({

		 url : 'http://localhost:3000/viewer/1',

		 dataType : 'json',

		 type : 'GET',

		 success : function(viewer){

		  	$viewerval.append(viewer.firstName)

		 }

		});

	});

	$('#viewer_login').click(function() {


		var $content = $('#content_list');

		var $email = $('#viewer_email');

		var $password= $('#viewer_password');

		var postData = {

		 	email: $email.val(),
		 	password: $password.val()

		 };

		$.ajax({

		 url : 'http://52.52.157.178:3000/viewer/login',

		 dataType : 'json',
		 contentType: "application/json",

		 data: postData,

		 type : 'POST',

		 done : function(viewer){
		 		console.log('viewer:', viewer);
		 
		 		$email.append(viewer)
	
		 },

		 always: function() {
		 	console.log('request sent');
		 }

		});

	});
});



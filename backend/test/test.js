function onClickHandler () {
	var postData = {
		email: 'user@test.com',
		password: '123'
	};
	
	url = "http://52.52.157.178:3000/viewer/login";
	var jqxhr = $.ajax(
		{
			method: "POST",
			url: url,
			data: postData
		}
	)
		.done(function(data) {
			$('#info').text(data.firstname);
			console.log(data);
		})
		.fail(function(error) {
			$('#info').html('error');
		});
}
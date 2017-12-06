$(document).ready(function()
{

	var userData = {
 storeUserDataInSession: function(userData) {
     var userObjectString = JSON.stringify(userData);
     window.sessionStorage.clear();
     window.sessionStorage.setItem('userObject',userObjectString)
 },
 getUserDataFromSession: function() {
     var userData = window.sessionStorage.getItem('userObject')
     return JSON.parse(userData);
 }
}
	var data=userData.getUserDataFromSession();
	console.log(data);



	for(var i=0; i<data.contentList.length ;i++){

		$('#viewerlogincontentrow').append(" <div class='col-md-4 col-sm-4 col-xs-12'> <div class='x_panel tile fixed_height_320'> <div class='x_title'>"+ "<h2> <a  href='display.html'>" +data.contentList[i].title +"</a></h2>"+ "<div class='widget_summary'> <div class='w_left w_35'>" + " <span>Details of Content</span>" + "<ul> <li>" +data.contentList[i].director + "</li>" + "<li>" + data.contentList[i].description + "</li> </ul>  <div class='w_right w_30'/>" +"</div> </div> </div> </div>");

	}

});
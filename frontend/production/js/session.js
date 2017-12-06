var userData = {
 storeUserDataInSession: function(userData) {
     var userObjectString = JSON.stringify(userData);
     window.sessionStorage.setItem('userObject',userObjectString)
 },
 getUserDataFromSession: function() {
     var userData = window.sessionStorage.getItem('userObject')
     return JSON.parse(userData);
 },
 clearUserDataFromSession: function()
 {
 	var userData = window.sessionStorage.clear();
 }

}
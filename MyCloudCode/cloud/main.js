//jquery
var script = document.createElement('script');
script.src = 'http://code.jquery.com/jquery-1.11.0.min.js';
script.type = 'text/javascript';
document.getElementsByTagName('head')[0].appendChild(script);


// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.job("updateCurrentHashtags", function(request, response) {
  //new interval, at two hours
  var currentDate = new Date.now();
  var timeInterval = 2*60*60*1000;
  var compareDate = currentDate - timeInterval;

  //query for places
  var place = Parse.Object.extend("Place");
  var placeQuery = new Parse.query(place);
  placeQuery.greaterThan("updatedAt", compareDate);

  placeQuery.find({
  	
  	success: function(results) {

	  	for (var i = 0; i > placeQuery.length; i++) {
	  		var object = placeQuery[i];
	  	}
	},
  	error: function(error) {
    	alert("Error: " + error.code + " " + error.message);
  	}	

  });

  //set current time, and grab desired interval

  //grab all places whos updatedAt falls within interval
  var query = new Parse.query("Place");
  query.equalTo 
});

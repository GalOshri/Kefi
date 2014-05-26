var MINIMUM_SCORE = 30;

// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("updateHashtags", function(request, response) {
  
  //cutoff time
  var currentDate = Date.now();
  var timeInterval = 10*60*60*1000;
  var compareDate = currentDate - timeInterval;

  //query for places
  var place = Parse.Object.extend("Place");
  var queryInInterval = new Parse.Query(place);
  queryInInterval.equalTo("objectId", "rJf8bERFCb");

  //here is where we grab all hashtags and update
  queryInInterval.find({
  	
  	success: function(results) {
	  	for (var i = 0; i < results.length; i++) {
	  		var place = results[i];
	  		var hashtags = place.get("hashtagList");

	  		var newTagsArray = [];
	  		for(var j=0; j<hashtags.length; j++) {
	  			if (hashtags[j]["score"] > MINIMUM_SCORE) {
	  				console.log(hashtags[j]["score"]);
	  				//add item to new array
	  				newTagsArray.push(hashtags[j]);
	  			}

	  		}
	  		place.set("hashtagList",newTagsArray);

	  		place.save();

	  	}
		response.success("currentDate " + currentDate + "    compareDate " + compareDate + "    results length " + results.length + " newTagsArray " + newTagsArray);
	},
  	error: function() {
    	response.error("uh oh");
  	}	

  });

//
//query for items before two hour interval
//
/*var queryOutInterval = new Parse.query(place);
queryOutInterval.lessThan("updatedAt", compareDate);
query.OutInterval.*/

});

var MINIMUM_SCORE = 30;
var NUM_HOURS_CUTOFF = 2;

// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("cleanHashtags", function(request, response) {
  
  //cutoff time
  var currentDate = Date.now();
  
  var timeInterval = NUM_HOURS_CUTOFF*60*60*1000;
  var cutoffDate = currentDate - timeInterval;
  cutoffDate = new Date(cutoffDate).toISOString();

  //query for places
  var Place = Parse.Object.extend("Place");
  var queryInTimeInterval = new Parse.Query(Place);
 
  //queryInInterval.equalTo("objectId", "rJf8bERFCb");
  queryInTimeInterval.greaterThan("updatedAt", {"__type":"Date","iso":cutoffDate});
 
  //here is where we grab all hashtags and update
  queryInTimeInterval.find({
  	
  	success: function(results) {
	  	for (var i = 0; i < results.length; i++) {
	  		var place = results[i];
	  		var hashtags = place.get("hashtagList");

	  		if (hashtags != undefined)
	  		{
		  		var newTagsArray = [];
		  		for(var j=0; j<hashtags.length; j++) {
		  			if (hashtags[j]["score"] > MINIMUM_SCORE) {
		  				//add item to new array
		  				newTagsArray.push(hashtags[j]);
		  			}
		  		}
		  		
		  		if(newTagsArray.length == 0) {
		  			place.unset("hashtagList");
		  			console.log("newtagsarray length 0!");
		  		}	

	  			else
	  				place.set("hashtagList",newTagsArray);
		  		
		  		place.save();
		  	}
	  	}
		response.success("silence is golden");
	},
  	error: function() {
    	response.error("uh oh");
  	}	
  });

  ///////////////////////////////////////
  //query Outside of time interval
  ///////////////////////////////////////
  var queryOutTimeInterval = new Parse.Query(Place);
  queryOutTimeInterval.lessThan("updatedAt", {"__type":"Date","iso":cutoffDate});

  queryOutTimeInterval.find({
  	success: function(results) {
	  	for (var i = 0; i < results.length; i++) {
	  		var place = results[i];
	  		var hashtags = place.get("hashtagList");

	  		if (hashtags != undefined) {
	  			//delete all hashtags if after the cutOff time
	  			place.unset("hashtagList");
				place.save();
	  		}
	  	}
	  	response.success("silence is golden");
	},
	error:function() {
    	response.error("uh oh");
    }
  });
});



/*
Parse.Cloud.define("updateSentimentEnergy", function(request, response) {


});*/

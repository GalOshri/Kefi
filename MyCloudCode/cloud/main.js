var MINIMUM_SCORE = 30;
var NUM_HOURS_CUTOFF = 2;
var ADDITIONAL_REVIEW_SCORE = 50;
var EXPONENTIAL_CONSTANT_HASHTAG = 0.0000001;
var EXPONENTIAL_CONSTANT_SENTIMENT_AND_ENERGY = 0.1;
var ADDITIONAL_SENTIMENT_AND_ENERGY_SCORE = 10;
var DAYS_CUTOFF_SENTIMENT_AND_ENERGY = 2;

Parse.Cloud.job("UpdatePlaces", function(request, status) {
  
	//cutoff time
	var currentDate = Date.now();

	var timeInterval = NUM_HOURS_CUTOFF*60*60*1000;
	var cutoffDate = currentDate - timeInterval;
	cutoffDate = new Date(cutoffDate).toISOString();

	

	//query for places
	var Place = Parse.Object.extend("Place");
	var query = new Parse.Query(Place);
	
	query.each(function(place) {
      // Update to place

      var hashtags = place.get("hashtagList");

      var updatedAt = place.updatedAt;
	  var deltaTUpdated = (currentDate - new Date(updatedAt));
	  var lastReviewed = place.get("lastReviewed");
		var deltaTReviewed = (currentDate - new Date(lastReviewed))



      // if array is empty, we don't need to do anything to this place
      if (hashtags.length != 0)
      {
	      var newTagsArray = [];
	      // if array is not empty, update scores of the hashtags
	      for (var i = 0; i < hashtags.length; i++)
	      {
	      	var hashtag = hashtags[i];

	      	// Update Hashtag score
	      	var newHashtagScore = hashtag["score"] * Math.exp(-1 * EXPONENTIAL_CONSTANT_HASHTAG * deltaTUpdated);
			hashtag["score"] = newHashtagScore;
			console.log(newHashtagScore);

	      	// Remove poor hashtags
	      	if (hashtag["score"] > MINIMUM_SCORE) 
	      	{
				//add item to new array
				newTagsArray.push(hashtags[i]);
			}
	      }

	      place.set("hashtagList",newTagsArray);
  		}

  		// Update Sentiment and Energy if this is old

  		if ((deltaTReviewed / (1000 * 60 * 60 * 24)) > DAYS_CUTOFF_SENTIMENT_AND_ENERGY)
  		{
  			place.set("sentiment", 100);
  			place.set("energy", 100);
  			place.set("confidence", 0);
  		}

      return place.save();
  }).then(function() {
    // Set the job's success status
    status.success("Place update cleaned successfully.");
  }, function(error) {
    // Set the job's error status
    status.error("Uh oh, something went wrong.");
  });
});





/*
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

  //query Outside of time interval
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
  }); */



/******
	called after a review save. updates Place object
*******/

Parse.Cloud.afterSave("Review", function(request, response) {	

	var currentDate = Date.now();
	var Place = Parse.Object.extend("Place");
	var updateTime = new Date ();
	//ToDo: check to see if there is a race condition of creating review before place
	var query = new Parse.Query(Place);

	query.get(request.object.get("place").id, {

		success:function(place) {
			var lastReviewed = place.get("lastReviewed");
			var deltaT = (currentDate - new Date(lastReviewed))/60000;
			console.log("lastReviewed is " + lastReviewed +" and currentDate is " + currentDate + " deltaT is " + deltaT);

			// grab hashtags
			existingHashtags = place.get("hashtagList");
			console.log("hashtagList is " + existingHashtags);
			var hashtags = request.object.get("hashtagStrings");

			var hashtagsToAdd = [];
			for (var i=0; i < hashtags.length; i++) {
				// check to see if this hashtag exists. undo case sensitivity
				// var hashtagIndex = existingHashtagLower.indexOf(hashtagsLower[i]);
				var isExisting = 0;
				if (existingHashtags != null)
				{	
					for (var j=0; j < existingHashtags.length; j++)
					{
						// This hashtag already exists
						// console.log("existingHashtag is " + existingHashtags[j]["text"] + " and hashtag is " + hashtags[i]);

						if (existingHashtags[j]["text"].toLowerCase() == hashtags[i].toLowerCase())
						{
							console.log("entered here with hashtag " + hashtags[i]);
							// FUNCTION INCREASE HASHTAG SCORE 
							var currentTagScore = existingHashtags[j]["score"];


							var newHashtagScore = existingHashtags[j]["score"] * Math.exp(-1 * EXPONENTIAL_CONSTANT_HASHTAG * deltaT) + ADDITIONAL_REVIEW_SCORE;
							existingHashtags[j]["score"] = newHashtagScore;

							isExisting = 1;
							break;
						}
					}
				}

				if (isExisting == 0) {
			
					// FUNCTION CREATE NEW HASHTAG
					var newHashtag = {"text" : hashtags[i], "score" : ADDITIONAL_REVIEW_SCORE};
					hashtagsToAdd.push(newHashtag);
					// console.log("created new tag with text " + newHashtag["text"] + " and score " + newHashtag["score"]);
				}
				
			}


			for (var i=0; i<hashtagsToAdd.length; i++)
				existingHashtags.push(hashtagsToAdd[i]);

			place.set("hashtagList", existingHashtags);


			// DEAL WITH SENTIMENT & ENERGY
			
			var oldScore = place.get("confidence");
			oldScore = oldScore * Math.exp(-1 * deltaT * EXPONENTIAL_CONSTANT_SENTIMENT_AND_ENERGY);

			var addedScore = ADDITIONAL_SENTIMENT_AND_ENERGY_SCORE;
			var totalScore = oldScore + addedScore;
			var newSentiment = (oldScore / totalScore) * place.get("sentiment") + (addedScore / totalScore) * request.object.get("sentiment");
			var newEnergy = (oldScore / totalScore) * place.get("energy") + (addedScore / totalScore) * request.object.get("energy");

			console.log("old sentiment and energy were " + place.get("sentiment") + " " + place.get("energy") + " and are now " + newSentiment + " " + newEnergy);
			console.log("score was " + place.get("confidence") + " and is now " + totalScore);
			// console.log("addedScore is " + addedScore + " and oldScore is " +oldScore);

			place.set("sentiment", Math.round(newSentiment));
			place.set("energy", Math.round(newEnergy));
			place.set("confidence", totalScore);
			
			place.set("lastReviewed", updateTime);

			place.save();
			
		},

		error: function(){
		}
	});
	

});


/******
	updateSentimentEnergy run as scheduled background job to update sentiment and energy of a place.
*******/
Parse.Cloud.define("updateSentimentAndEnergy", function(request, response) {
	response.success("called a function w/i a function, brah!");
	console.log(request["sentiment"]);
	// set vars from 

});

/******
	Return object of our custom values
*******/
Parse.Cloud.define("getConfigObject", function(request, response) {
	var kefiHashtags = ["LustyIntentions", "TurnDownForWhat", "Crickets", "TooSoberForThis", "GenerousBartender", "DanceAllNight", "LinesForDays", "CasualBlackout"];
	var configObject = {"Hi" : 5, "Boo" : 10, "kefiHashtags" : kefiHashtags};
	response.success(configObject);

});




//
//  KefiService.m
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "KefiService.h"



@implementation KefiService

#pragma mark - FourSquare request variables
NSString *client_id = @"T4XPWMEQAID11W0CSQLCP2P0NXGEUSDZRV4COSBJH2QEMC2O";
NSString *client_secret = @"0P1EQQ3NH102D0R3GNGTG0ZAL0S5T41YDB2NPOOMRMO2I2EO";
NSString *category_id =  @"4bf58dd8d48988d116941735,50327c8591d4c4b30a586d5d,4bf58dd8d48988d11e941735,4bf58dd8d48988d118941735,4bf58dd8d48988d1d8941735,4bf58dd8d48988d120941735,4bf58dd8d48988d121941735,4bf58dd8d48988d11f941735,4bf58dd8d48988d11b941735,4bf58dd8d48988d1d4941735,4bf58dd8d48988d11d941735,4bf58dd8d48988d122941735,4bf58dd8d48988d123941735";
int radius = 1000;

#pragma mark - Populate Place List View
+ (void) PopulatePlaceList:(PlaceList *)placeList withTable:(UITableView *)tableView withLocation:(CLLocation *)currentLocation withSpinner:(UIActivityIndicatorView *)spinner
{
    [self PopulatePlaceList:placeList withTable:tableView withSearchTerm:@"" withLocation:currentLocation withSpinner:spinner];
}

+ (void) PopulatePlaceList:(PlaceList *)placeList withTable:(UITableView *)tableView withSearchTerm:(NSString *)searchTerm withLocation:(CLLocation *)currentLocation withSpinner:(UIActivityIndicatorView *)spinner
{
    [spinner startAnimating];
    
    NSString *fsURLString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&radius=%d&intent=browse&categoryId=%@&client_id=%@&client_secret=%@&v=%d",
                             currentLocation.coordinate.latitude,
                             currentLocation.coordinate.longitude,
                             radius,
                             category_id,
                             client_id,
                             client_secret,
                             20140306];
    
    if (![searchTerm isEqualToString:@""])
    {
        fsURLString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&radius=%d&intent=browse&categoryId=%@&client_id=%@&client_secret=%@&v=%d&query=%@",
                       currentLocation.coordinate.latitude,
                       currentLocation.coordinate.longitude,
                       10000,
                       category_id,
                       client_id,
                       client_secret,
                       20140306,
                       searchTerm];
        
        fsURLString = [fsURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:fsURLString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                NSError *jsonError;
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                NSDictionary *responseDict = [jsonDict objectForKey:@"response"];
                NSArray *venueArray = [responseDict objectForKey:@"venues"];
                
                for (int i = 0; i < [venueArray count]; i++)
                {
                    NSDictionary *venue = [venueArray objectAtIndex:i];
                    NSDictionary *location = [venue objectForKey:@"location"];
                    
                    Place *place = [[Place alloc] init];
                    place.fsId = [NSString stringWithFormat:@"%@",[venue objectForKey:@"id"]];
                    place.name = [NSString stringWithFormat:@"%@",[venue objectForKey:@"name"]];
                    place.address = [NSString stringWithFormat:@"%@",[location objectForKey:@"address"]];
                    place.crossStreet = [NSString stringWithFormat:@"%@", [location objectForKey:@"crossStreet"]];
                    place.currentDistance = [location objectForKey:@"distance"];
                    place.latLong = @[[location objectForKey: @"lat"],[location objectForKey:@"lng"]];
                    
                    
                    
                    //modify currentDistance to represent miles
                    place.currentDistance =  @([place.currentDistance doubleValue]* 0.000621371192);
                  
                    //grab image url
                   /* NSString *imageURL = [NSString stringWithFormat:@"%@%@%@",
                                          [[[[venue objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"icon"] objectForKey:@"prefix"],
                                          @"bg_64",
                                          [[[[venue objectForKey:@"categories"] objectAtIndex:0]objectForKey:@"icon"]objectForKey:@"suffix"]
                                          ];
                    
                    NSURL *imageURLConcat = [NSURL URLWithString:imageURL];
                    NSData *imageData = [NSData dataWithContentsOfURL:imageURLConcat];
                    place.imageType = [UIImage imageWithData:imageData];*/
                 
                    //grab category type
                    place.categoryType = [NSString stringWithFormat:@"%@", [[[venue objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"name"]];
                    
                    
                    //set pid, sentiment, energy to values for checking later
                    place.pId = @"";
                    place.sentiment = [NSNumber numberWithInt:100];
                    place.energy = [NSNumber numberWithInt:-1];
                    
                    [placeList.places addObject:place];
                    
                    
                }
                //make call to populate with parse data
                if (![searchTerm isEqualToString:@""])
                    [self PopulateWithParseData: placeList withTableView:tableView withSpinner:spinner];
                else
                    [self PopulateWithParseData: placeList withTableView:tableView withSpinner:spinner];
                
                [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                
                
            }] resume];
}

+ (void) PopulateFavoritePlaceList:(PlaceList *)placeList withTable:(UITableView *)tableView withLocation:(CLLocation *)currentLocation withSpinner:(UIActivityIndicatorView *)spinner
{
    [spinner startAnimating];
    
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSArray *favoritePlaces = [userData objectForKey:@"FavoritePlaces"];
  
    for (NSString *favoritePlaceFsId in favoritePlaces)
    {
        Place *place = [[Place alloc] init];
        place.fsId = [NSString stringWithString:favoritePlaceFsId];
        
        // TODO: Set the other fields as necessary
        place.pId = @"";
        place.sentiment = [NSNumber numberWithInt:100];
        place.energy = [NSNumber numberWithInt:-1];
        place.currentDistance = nil;
        place.crossStreet = @"";
        place.address = @"";
        
        
        [placeList.places addObject:place];
    }
    
    [self PopulateWithParseData: placeList withTableView:tableView withSpinner:spinner];
    /*
        
        NSString *fsURLString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?ll=%f,%f&client_id=%@&client_secret=%@&v=%d",
                                 
                                 favoritePlaceFsId,
                                 currentLocation.coordinate.latitude,
                                 currentLocation.coordinate.longitude,
                                 client_id,
                                 client_secret,
                                 20140306];
        
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:fsURLString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                NSError *jsonError;
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                NSDictionary *responseDict = [jsonDict objectForKey:@"response"];
                NSDictionary *venue = [responseDict objectForKey:@"venue"];
                

                NSDictionary *location = [venue objectForKey:@"location"];
                
                Place *place = [[Place alloc] init];
                place.fsId = [NSString stringWithFormat:@"%@",[venue objectForKey:@"id"]];
                place.name = [NSString stringWithFormat:@"%@",[venue objectForKey:@"name"]];
                place.address = [NSString stringWithFormat:@"%@",[location objectForKey:@"address"]];
                place.crossStreet = [NSString stringWithFormat:@"%@", [location objectForKey:@"crossStreet"]];
                place.currentDistance = [location objectForKey:@"distance"];
                place.latLong = @[[location objectForKey: @"lat"],[location objectForKey:@"lng"]];
                
                
                
                //modify currentDistance to represent miles
                place.currentDistance =  @([place.currentDistance doubleValue]* 0.000621371192);
                
                //grab image url
                 NSString *imageURL = [NSString stringWithFormat:@"%@%@%@",
                 [[[[venue objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"icon"] objectForKey:@"prefix"],
                 @"bg_64",
                 [[[[venue objectForKey:@"categories"] objectAtIndex:0]objectForKey:@"icon"]objectForKey:@"suffix"]
                 ];
                 
                 NSURL *imageURLConcat = [NSURL URLWithString:imageURL];
                 NSData *imageData = [NSData dataWithContentsOfURL:imageURLConcat];
                 place.imageType = [UIImage imageWithData:imageData];
                
                //grab category type
                place.categoryType = [NSString stringWithFormat:@"%@", [[[venue objectForKey:@"categories"] objectAtIndex:0] objectForKey:@"name"]];
                
                
                //set pid, sentiment, energy to values for checking later
                place.pId = @"";
                place.sentiment = [NSNumber numberWithInt:100];
                place.energy = [NSNumber numberWithInt:-1];
                
                [placeList.places addObject:place];
                
                counter = counter + 1;
                
                if (counter == (int)[favoritePlaces count])
                {
                    [self PopulateWithParseData: placeList withTableView:tableView withSpinner:spinner];
                    
                    [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                        
                }
            }] resume];*/
        
    
}

+ (void) PopulateWithParseData:(PlaceList *)placeList withTableView:(UITableView *)tableView withSpinner:(UIActivityIndicatorView *)spinner
{
    // get date within time interval
    NSDate *beginningTimeInterval = [[NSDate alloc] initWithTimeInterval:(NSTimeInterval)-7200 sinceDate:[NSDate new]];
    
    //grab all fsIds for placeList.places
    NSArray *fsIdArray = [placeList.places valueForKey:@"fsId"];
    
    //query to grab pIds from Parse
    PFQuery *queryItems = [PFQuery queryWithClassName:@"Place"];
    [queryItems whereKey:@"fsID" containedIn:fsIdArray];
    
    //perform actions to update placeList.places
    [queryItems findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            for (PFObject *object in objects) {
                NSArray *matchedPlaceArray = [placeList.places filteredArrayUsingPredicate:[NSPredicate
                                                      predicateWithFormat:@"fsId == %@", [object objectForKey:@"fsID"]]];
                if ([matchedPlaceArray count] == 0)
                    continue;
                
                Place *place = [matchedPlaceArray objectAtIndex:0];
                place.pId = [object valueForKey:@"objectId"];
                place.lastReviewedTime = [object valueForKey:@"lastReviewed"];
                place.sentiment = [object valueForKey:@"sentiment"];
                place.energy = [object valueForKey:@"energy"];
                PFGeoPoint *location = [object valueForKey:@"location"];
                NSArray *latLongArray = @[[NSNumber numberWithDouble:[location latitude]], [NSNumber numberWithDouble:[location longitude]]];
                place.latLong = latLongArray;
                place.name = [NSString stringWithString:[object valueForKey:@"name"]];
                place.categoryType = [NSString stringWithString:[object valueForKey:@"category"]];
                
                
                //hashtags
                for (id hashtagObject in [object valueForKey:@"hashtagList"])
                {
                    Hashtag *hashtag = [[Hashtag alloc] initWithText:[hashtagObject valueForKey:@"text"] withScore:[hashtagObject valueForKey:@"score"]];
                    [place.hashtagList addObject:hashtag];
                }
                
                // sort hashtags
                [place sortHashtags];
                
                // isInInterval to see if cell in active/inactive state
                place.isInInterval = NO;
                
                NSDate *earlierDate = [beginningTimeInterval earlierDate:place.lastReviewedTime];
                if ([earlierDate isEqualToDate:beginningTimeInterval]) {
                    place.isInInterval = YES;
                }
                // NSLog(@"%d, lastreviewed %@ and begtimeinterval is %@", place.isInInterval, place.lastReviewedTime, beginningTimeInterval);
                
                // NSLog(@"%d", place.isInInterval);
            }
            
            [spinner stopAnimating];
            [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            
        
            
            
            
        }
        
        else {
            NSLog(@"%@", [error userInfo]);
        }
    }];
}

#pragma mark - Reviews
+ (void) AddReviewforPlace:(Place *)place withSentiment:(int)sentiment withEnergy:(int)energy withHashtagStrings:(NSArray *)hashtagStrings withPlaceDetailView:(PlaceDetailView *)pdv
{
    [pdv.spinner startAnimating];
    
    //create review PFObject
    PFObject *reviewObject = [PFObject objectWithClassName: @"Review"];
    
    //store sentiment, energy, pId
    reviewObject[@"sentiment"] = [NSNumber numberWithInt:sentiment];
    reviewObject[@"energy"] = [NSNumber numberWithInt:energy];
    reviewObject[@"placeName"] = place.name;
    reviewObject[@"hashtagStrings"] = hashtagStrings;
    reviewObject[@"user"] = [PFUser currentUser];

    
    if (![place.pId isEqualToString:@""])
    {
        reviewObject[@"place"] = [PFObject objectWithoutDataWithClassName:@"Place" objectId:place.pId];
        
        //TODO: update lastUpdated, scores for Place
    }
    
    else
    {
        //create new place and save in background.
        //TODO: move server side
        PFObject *placeObject = [PFObject objectWithClassName:@"Place"];
        placeObject[@"fsID"] = place.fsId;
        placeObject[@"name"] = place.name;
        placeObject[@"location"] = [PFGeoPoint geoPointWithLatitude:[[place.latLong objectAtIndex:0] doubleValue] longitude:[[place.latLong objectAtIndex:1] doubleValue]];
        placeObject[@"category"] = place.categoryType;
        placeObject[@"hashtagList"] = [[NSArray alloc] initWithObjects:nil];
        
        placeObject[@"sentiment"] = [NSNumber numberWithInt:100];
        placeObject[@"energy"] = [NSNumber numberWithInt:100];
        placeObject[@"confidence"] = [NSNumber numberWithInt:0];
        
        placeObject[@"lastReviewed"] = [NSDate new];
        place.pId = [NSString stringWithString:placeObject.objectId];
        
        [placeObject saveInBackground];
        
        reviewObject[@"place"] = placeObject;
        
    }
    

    //reviewObject SaveInBackground
    [reviewObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        // Update place's sentiment and energy, and lastReviewedTime
        
        //query to grab pIds from Parse
        PFQuery *queryItems = [PFQuery queryWithClassName:@"Place"];
        [queryItems whereKey:@"fsID" equalTo:place.fsId];
        
        //perform actions to update placeList.places
        [queryItems getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!object) {
                NSLog(@"error executing lookup to get new sentiment after submit");
                [pdv.spinner stopAnimating];
            }
            
            // success
            else {
                place.sentiment = [object objectForKey:@"sentiment"];
                place.energy = [object objectForKey:@"energy"];
                place.lastReviewedTime = [NSDate date]; // do we need this?
                place.isInInterval = YES;
                [place sortHashtags];
                [pdv setSentimentImage];
                
                [pdv.spinner stopAnimating];
                
                [pdv.hashtagView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                
            }
            
            
        }];

    }];
    
}

+ (void) PopulateReviews:(NSMutableArray *)reviewList forUser:(PFUser *)user withTable:(UITableView *)tableView
{
    PFQuery *query = [PFQuery queryWithClassName:@"Review"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *parseReview in objects)
        {
            Review *review = [[Review alloc] init];
            review.sentiment = [parseReview[@"sentiment"] intValue];
            review.energy = [parseReview[@"energy"] intValue];
            review.reviewTime = parseReview.createdAt;
            review.placeName = [NSString stringWithString:parseReview[@"placeName"]];
            
            for (NSString *parseHashtag in parseReview[@"hashtagStrings"])
            {
                NSString *hashtag = [NSString stringWithString:parseHashtag];
                [review.hashtags addObject:hashtag];
            }
            [reviewList addObject:review];
        }
        
        [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }];
    
    
}

#pragma mark - Get Settings

+ (void) GetKefiSettings:(PlaceListView *)plv;
{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    
    NSDate *lastUpdated = [userData objectForKey:@"lastUpdated"];
    NSDate *currentDate = [NSDate date];
    NSNumber *updateInterval = [userData objectForKey:@"updateInterval"];
    
    // if we recently updated, return
    if (lastUpdated != nil)
    {
        NSTimeInterval secondsSinceUpdate = [currentDate timeIntervalSinceDate:lastUpdated];
        double numberOfDays = secondsSinceUpdate / 86400.0;
        if (updateInterval != nil)
        {
            if (numberOfDays < [updateInterval doubleValue])
                return;
        }
    }

    [PFCloud callFunctionInBackground:@"getConfigObject"
                       withParameters:@{}
                                block:^(NSDictionary *result, NSError *error) {
                                    if (!error) {

                                        NSArray *kefiHashtags = [result objectForKey:@"kefiHashtags"];
                                        [userData setObject:kefiHashtags forKey:@"kefiHashtags"];
                                        
                                        NSArray *spotlightURLs = [result objectForKey:@"spotlightURLs"];
                                        [userData setObject:spotlightURLs forKey:@"spotlightURLs"];
                                        
                                        NSArray *spotlightCaptions = [result objectForKey:@"spotlightCaptions"];
                                        [userData setObject:spotlightCaptions forKey:@"spotlightCaptions"];
                                        
                                        NSNumber *newUpdateInterval = [result objectForKey:@"updateInterval"];
                                        [userData setObject:newUpdateInterval forKey:@"updateInterval"];
                                        
                                        [userData synchronize];
                                        
                                        
                                        [plv performSelectorOnMainThread:@selector(setUpSpotlight) withObject:nil waitUntilDone:NO];
                                    }
                                }];   
}

#pragma mark - Favorites

+ (void) addFavorite:(Place *)place
{
    // Add to local favorites
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favoritePlaces = [[userData objectForKey:@"FavoritePlaces"] mutableCopy];
    if (favoritePlaces == nil)
    {
        favoritePlaces = [[NSMutableArray alloc] initWithObjects:place.fsId, nil];
    }
    else
    {
        if (![favoritePlaces containsObject:place.fsId])
            [favoritePlaces addObject:place.fsId];
    }
    [userData setObject:favoritePlaces forKey:@"FavoritePlaces"];
    [userData synchronize];
    
    // Add to DB if place doesn't exist
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query whereKey:@"fsID" equalTo:place.fsId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            // Create place
            NSLog(@"The getFirstObject request failed.");
            PFObject *placeObject = [PFObject objectWithClassName:@"Place"];
            placeObject[@"fsID"] = place.fsId;
            placeObject[@"name"] = place.name;
            placeObject[@"location"] = [PFGeoPoint geoPointWithLatitude:[[place.latLong objectAtIndex:0] doubleValue] longitude:[[place.latLong objectAtIndex:1] doubleValue]];
            placeObject[@"category"] = place.categoryType;
            placeObject[@"hashtagList"] = [[NSArray alloc] initWithObjects:nil];
            
            placeObject[@"sentiment"] = [NSNumber numberWithInt:100];
            placeObject[@"energy"] = [NSNumber numberWithInt:100];
            placeObject[@"confidence"] = [NSNumber numberWithInt:0];
            
            placeObject[@"lastReviewed"] = [NSDate new];
            place.pId = [NSString stringWithString:placeObject.objectId];
            
            [placeObject saveInBackground];
            
        } else {
            // Place exists so don't do anything.
            NSLog(@"Successfully retrieved the object.");
        }
    }];
}

+ (void) removeFavorite:(NSString *)fsId
{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favoritePlaces = [[userData objectForKey:@"FavoritePlaces"] mutableCopy];
    if (favoritePlaces == nil)
    {
        favoritePlaces = [[NSMutableArray alloc] init];
    }
    else
    {
        if ([favoritePlaces containsObject:fsId])
            [favoritePlaces removeObject:fsId];
    }
    [userData setObject:favoritePlaces forKey:@"FavoritePlaces"];
    [userData synchronize];
}

+ (BOOL) isFavorite:(NSString *)fsId
{
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSArray *favoritePlaces = [userData objectForKey:@"FavoritePlaces"];
    if (favoritePlaces == nil)
    {
        return NO;
    }
    else
    {
        if ([favoritePlaces containsObject:fsId])
            return YES;
        else
            return NO;
    }
    
}

#pragma mark - Feedback

+ (void) submitFeedback:(NSString *)feedback
{
    PFUser *user = [PFUser currentUser];
    
    // Make a new post
    PFObject *feedbackObject = [PFObject objectWithClassName:@"Feedback"];
    feedbackObject[@"text"] = feedback;
    if ([PFUser currentUser])
        feedbackObject[@"user"] = user;
    [feedbackObject save];
}

#pragma mark - Beta News

+ (void) GetBetaNews:(BetaNewsView *)bnv;
{
    [bnv.spinner startAnimating];
    [PFCloud callFunctionInBackground:@"getBetaNews"
                       withParameters:@{}
                                block:^(NSDictionary *result, NSError *error) {
                                    if (!error) {
                                        
                                        NSString *betaNewsString = [result objectForKey:@"betaNewsString"];
                                        bnv.betaNewsTextView.text = [NSString stringWithString:betaNewsString];
                                        [bnv.spinner stopAnimating];
                                    }
                                }];   
}


@end

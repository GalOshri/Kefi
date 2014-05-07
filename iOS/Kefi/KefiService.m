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
NSInteger radius = 1000;

+ (void) PopulatePlaceList:(PlaceList *)placeList withTable:(UITableView *)tableView
{
    [self PopulatePlaceList:placeList withTable:tableView withSearchTerm:@""];
}



+ (void) PopulatePlaceList:(PlaceList *)placeList withTable:(UITableView *)tableView withSearchTerm:(NSString *)searchTerm
{
    NSString *fsURLString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&radius=%d&intent=browse&categoryId=%@&client_id=%@&client_secret=%@&v=%d",
                             47.615925,
                             -122.326968,
                             radius,
                             category_id,
                             client_id,
                             client_secret,
                             20140306];
    
    if (![searchTerm isEqualToString:@""])
    {
        fsURLString = [fsURLString stringByAppendingFormat:@"&query=%@",searchTerm];
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

                    //NSLog(@"distance is: %@",place.currentDistance);
                    
                    //modify currentDistance to represent miles
                    place.currentDistance =  @([place.currentDistance doubleValue]* 0.000621371192);
                    //NSLog(@"in miles is: %@",place.currentDistance);
                    
                    
                    
                    for (int j = 0; j < 6; j++)
                    {
                        Hashtag *hashtag = [[Hashtag alloc] init];
                        hashtag.text = [NSString stringWithFormat:@"Hashtag%d", j];
                        [place.hashtagList addObject:hashtag];
                    }
                    
                    [placeList.places addObject:place];
                }
                
                
                
                [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                
            }] resume];
}


+ (void) PopulateHashtagList:(NSMutableArray *)hashtagList
{
    for (int i = 0; i < 5; i++)
    {
        Hashtag *hashtag = [[Hashtag alloc] init];
        hashtag.text = [NSString stringWithFormat:@"Hashtag %d", i];
        [hashtagList addObject:hashtag];
    }
}

+ (void) PopulateHashtagCatList:(NSMutableArray *)hashtagCatList
{
    
}


/*

+ (void) PopulatePlaceDetailView: (Place *)place withPlaceAddress:(UILabel *)placeAddress withPlaceCrossStreet: (UILabel *)placeCrossStreets{
  
    //initialize array
    NSString *fsURLString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/%@?client_id=%@&client_secret=%@&v=%d",
                             place.fsId,
                             client_id,
                             client_secret,
                             20140306];
   
    //NSLog(@"the URL is %@", fsURLString);
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:[NSURL URLWithString:fsURLString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSDictionary *responseDict = [jsonDict objectForKey:@"response"];
            NSDictionary *venue = [responseDict objectForKey:@"venue"];
            //NSLog(@"responseDict is %@,\n venue is %@",responseDict, venue);
                
            //grab data here
            NSDictionary *location= [[NSDictionary alloc] init];
            location = [venue objectForKey:@"location"];
                
            //define place instance
            //place.fsId = [NSString stringWithFormat:@"%@",[location objectForKey:@"id"]];
            //place.name = [NSString stringWithFormat:@"%@",[location objectForKey:@"name"]];
            place.address = [NSString stringWithFormat:@"%@",[location objectForKey:@"address"]];
            place.crossStreet = [NSString stringWithFormat:@"%@", [location objectForKey:@"crossStreet"]];


            //what to do with data reload the view so that we see changes.
            //set name and all other attributes here
            //self.placeTitle.text = self.place.name;
            placeAddress.text = place.address;
            placeCrossStreets.text = place.crossStreet;
    
      }] resume];
}
*/

@end

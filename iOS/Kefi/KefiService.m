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
    // TEST CODE FOR HTTP REQUEST
    
    NSString *fsURLString = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&radius=%d&intent=browse&categoryId=%@&client_id=%@&client_secret=%@&v=%d",
                             47.615925,
                             -122.326968,
                             radius,
                             category_id,
                             client_id,
                             client_secret,
                             20140306];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:fsURLString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
//                NSString *strData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//                NSLog(@"%@",strData);
                NSError *jsonError;
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                NSDictionary *responseDict = [jsonDict objectForKey:@"response"];
                NSArray *venueArray = [responseDict objectForKey:@"venues"];
            
                for (int i = 0; i < 30; i++)
                {
                    NSDictionary *venue = [venueArray objectAtIndex:i];
                    NSLog(@"%@", [venue objectForKey:@"name"]);
                    
                    
                    Place *place = [[Place alloc] init];
                    place.fsId = @"ABC";
                    place.name = [NSString stringWithFormat:@"%@",[venue objectForKey:@"name"]];
                    [placeList.places addObject:place];
                }
                
                [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                
            }] resume];
    

}

@end

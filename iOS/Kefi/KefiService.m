//
//  KefiService.m
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "KefiService.h"

@implementation KefiService

+ (void) PopulatePlaceList:(PlaceList *)placeList withTable:(UITableView *)tableView
{
    // TEST CODE FOR HTTP REQUEST
    
    NSString *fsURLString = @"https://api.foursquare.com/v2/venues/search?ll=47.615925,-122.326968&client_id=JN00ABQBOCK5V54FQ1TWQFLOOIDU12UAZXURHXGXNK0ESJBY&client_secret=14ES1NXTCL1XC5HSLBUT4LWE4ROEDGNYKKWGGERZQGUKQ5JC&v=20120609";
    
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
            
                for (int i = 0; i < 5; i++)
                {
                    NSDictionary *venue = [venueArray objectAtIndex:i];
                    NSLog(@"%@", [venue objectForKey:@"name"]);
                    
                    
                    Place *place = [[Place alloc] init];
                    place.fsId = @"ABC";
                    place.name = [NSString stringWithFormat:@"%@",[venue objectForKey:@"name"]];
                    [placeList.places addObject:place];
                }
                
                
                [tableView reloadData];
            }] resume];
    
    
}

@end

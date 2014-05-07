//
//  KefiService.h
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceList.h"
#import "Hashtag.h"
#import "Place.h"

@interface KefiService : NSObject

+ (void) PopulatePlaceList:(PlaceList *)placeList withTable:(UITableView *)tableView;
+ (void) PopulatePlaceList:(PlaceList *)placeList withTable:(UITableView *)tableView withSearchTerm:(NSString *)searchTerm;

+ (void) PopulateHashtagList:(NSMutableArray *)hashtagList;
+ (void) PopulateHashtagCatList:(NSMutableArray *)hashtagCatList;

//+ (void) PopulatePlaceDetailView: (Place *)place withPlaceAddress:(UILabel *)placeAddress withPlaceCrossStreet: (UILabel *)placeCrossStreets;
@end

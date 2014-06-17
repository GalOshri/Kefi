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
#import "PlaceDetailView.h"


@interface KefiService : NSObject

+ (void) PopulatePlaceList:(PlaceList *)placeList withTable:(UITableView *)tableView withLocation:(CLLocation *)currentLocation withTableHeader:(UIView *)tableHeader withSpinner:(UIActivityIndicatorView *)spinner;

+ (void) PopulatePlaceList:(PlaceList *)placeList withTable:(UITableView *)tableView withSearchTerm:(NSString *)searchTerm withLocation:(CLLocation *)currentLocation withTableHeader:(UIView *)tableHeader withSpinner:(UIActivityIndicatorView *)spinner;

+ (void) AddReviewforPlace:(Place *)place withSentiment:(int)sentiment withEnergy:(int)energy withHashtagStrings:(NSArray *)hashtagStrings withPlaceDetailView:(PlaceDetailView *)pdv;

+ (void) GetKefiSettings;


+(void) loginTosocialNetwork;


@end

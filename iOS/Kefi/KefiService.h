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

// Populate place list view
+ (void) PopulatePlaceList:(PlaceList *)placeList withTable:(UITableView *)tableView withLocation:(CLLocation *)currentLocation withSpinner:(UIActivityIndicatorView *)spinner;

+ (void) PopulatePlaceList:(PlaceList *)placeList withTable:(UITableView *)tableView withSearchTerm:(NSString *)searchTerm withLocation:(CLLocation *)currentLocation withSpinner:(UIActivityIndicatorView *)spinner;

+ (void) PopulateFavoritePlaceList:(PlaceList *)placeList withTable:(UITableView *)tableView withLocation:(CLLocation *)currentLocation withSpinner:(UIActivityIndicatorView *)spinner;

// Review a place
+ (void) AddReviewforPlace:(Place *)place withSentiment:(int)sentiment withEnergy:(int)energy withHashtagStrings:(NSArray *)hashtagStrings withPlaceDetailView:(PlaceDetailView *)pdv;

// Get Settings
+ (void) GetKefiSettings;

// Favorites
+ (void) addFavorite:(NSString *)fsId;

+ (void) removeFavorite:(NSString *)fsId;

+ (BOOL) isFavorite:(NSString *)fsId;

// Feedback
+ (void) submitFeedback:(NSString *)feedback;


@end

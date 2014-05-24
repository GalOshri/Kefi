//
//  Place.h
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hashtag.h"

@interface Place : NSObject

// Place details
@property (nonatomic, strong) NSString *fsId;
@property (nonatomic, strong) NSString *pId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *crossStreet;

@property (nonatomic, strong) NSNumber *currentDistance;
@property (nonatomic, strong) UIImage *imageType;
@property (nonatomic, strong) NSString *categoryType;
@property (nonatomic, strong) NSArray *latLong;

// Review information
@property (nonatomic, strong) NSMutableArray *hashtagList;
@property (nonatomic, strong) NSNumber *sentiment;
@property (nonatomic, strong) NSNumber *energy;
@property (nonatomic, strong) NSDate *lastReviewedTime;

- (id)initWithId:(NSString *)fsId
        WithName:(NSString *)placeName;

- (void)addHashtag:(NSString *)text;

- (void)submitSentiment:(int)newSentiment;
- (void)submitEnergy:(int)newEnergy;
- (void)updateLastReviewTime;

@end

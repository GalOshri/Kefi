//
//  Place.m
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "Place.h"

@implementation Place

- (NSMutableArray *)hashtagList
{
    if (!_hashtagList)
    {
        _hashtagList = [[NSMutableArray alloc] init];
    }
    
    return _hashtagList;
}

- (id)initWithId:(NSString *)fsId
        WithName:(NSString *)placeName;
{
    self = [super init];
    
    if (self)
    {
        self.fsId = [NSString stringWithString:fsId];
        self.name = [NSString stringWithString:placeName];
    }
    
    return self;
}

- (void)addHashtag:(NSString *)text
{
    Hashtag *newHashtag = [[Hashtag alloc] initWithText:text];
    [self.hashtagList addObject:newHashtag];
}

// TODO: Actually do something useful
- (void)submitSentiment:(int)newSentiment
{
    double sentiment = [self.sentiment doubleValue];
    sentiment = (sentiment + newSentiment) / 2.0; // TODO: GET THIS FROM THE SERVICE
    self.sentiment = [NSNumber numberWithDouble:sentiment];
}

// TODO: Actually do something useful
- (void)submitEnergy:(int)newEnergy
{
    double energy = [self.energy doubleValue];
    energy = (energy + energy) / 2.0; // TODO: GET THIS FROM THE SERVICE
    self.energy = [NSNumber numberWithDouble:energy];
}

- (void)updateLastReviewTime
{
    self.lastReviewedTime = [NSDate date];
}

@end

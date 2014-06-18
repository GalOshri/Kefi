//
//  Place.m
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "Place.h"
#import <Parse/Parse.h>

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
- (void)updatePlaceAfterReview
{
    //NSLog(@"updatePlaceAfterReview");
    //query to grab pIds from Parse
    PFQuery *queryItems = [PFQuery queryWithClassName:@"Place"];
    [queryItems whereKey:@"fsID" equalTo:self.fsId];
    
    //perform actions to update placeList.places
    [queryItems getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"error executing lookup to get new sentiment after submit");
        }
        
        // success
        else {
            self.sentiment = [object objectForKey:@"sentiment"];
            self.energy = [object objectForKey:@"energy"];
            self.lastReviewedTime = [NSDate date]; // do we need this?
            self.isInInterval = YES;
            //NSLog(@"grabbed place after review with sentiment %@ and energy %@", self.sentiment, self.energy);

        }
        
   
    }];
}

-(void)sortHashtags {
    // sort hashtags
    NSSortDescriptor *hashtagSorter = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:FALSE];
    NSArray *sortedHashtags = [NSArray arrayWithObject:hashtagSorter];
    [self.hashtagList sortUsingDescriptors:sortedHashtags];
    
}

@end

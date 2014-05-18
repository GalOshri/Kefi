//
//  Hashtag.m
//  Kefi
//
//  Created by Gal Oshri on 4/9/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "Hashtag.h"

@implementation Hashtag

- (id)initWithText:(NSString *)text
{
    self = [super init];
    
    if (self)
    {
        self.text = [NSString stringWithString:text];
        self.score = [NSNumber numberWithDouble:50.0]; // TODO: GET THIS FROM THE SERVICE
        self.lastSubmitTime = [NSDate date];
    }
    
    return self;
}

// Someone just added a review with this existing hashtag
- (void)addReview
{
    double score = [self.score doubleValue];
    self.score = [NSNumber numberWithDouble:score + 50]; // TODO: GET THIS FROM THE SERVICE
    self.lastSubmitTime = [NSDate date];
}



@end

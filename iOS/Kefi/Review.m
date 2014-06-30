//
//  Review.m
//  Kefi
//
//  Created by Gal Oshri on 6/26/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "Review.h"

@implementation Review

- (NSMutableArray *)hashtags
{
    if (!_hashtags)
    {
        _hashtags = [[NSMutableArray alloc] init];
    }
    
    return _hashtags;
}

- (NSDate *)reviewTime
{
    if (!_reviewTime)
    {
        _reviewTime = [[NSDate alloc] init];
    }
    
    return _reviewTime;
}


- (NSString *)placeName
{
    if (!_placeName)
    {
        _placeName = [[NSString alloc] init];
    }
    
    return _placeName;
}

@end

//
//  Place.m
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "Place.h"

@implementation Place

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

@end

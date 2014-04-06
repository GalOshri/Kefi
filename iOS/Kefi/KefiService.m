//
//  KefiService.m
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "KefiService.h"

@implementation KefiService

+ (void) PopulatePlaceList:(PlaceList *)placeList
{
    for (int i = 0; i < 5; i++)
    {
        Place *place = [[Place alloc] init];
        place.fsId = @"ABC";
        place.name = [NSString stringWithFormat:@"Cool Place %d",i];
        [placeList.places addObject:place];
    }
}

@end

//
//  PlaceList.m
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "PlaceList.h"


@implementation PlaceList

- (NSMutableArray *)places
{
    if (!_places)
    {
        _places = [[NSMutableArray alloc] init];
    }
    
    return _places;
}

@end

//
//  MapAnnotation.m
//  Kefi
//
//  Created by Paul Stavropoulos on 5/25/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;


- (id)initWithCoordinates:(CLLocationCoordinate2D)location
                placeName:(NSString *)placeName
              description:(NSString *)description;
{
    self = [super init];
    if (self)
    {
        coordinate = location;
        title = placeName;
        subtitle = description;
    }
    
    return self;
}
@end

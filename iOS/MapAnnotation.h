//
//  MapAnnotation.h
//  Kefi
//
//  Created by Paul Stavropoulos on 5/25/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* subtitle;
    
- (id)initWithCoordinates:(CLLocationCoordinate2D)location
placeName:(NSString *)placeName
description:(NSString *)description;

@end

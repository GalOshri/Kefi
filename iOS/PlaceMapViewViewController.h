//
//  PlaceMapViewViewController.h
//  Kefi
//
//  Created by Paul Stavropoulos on 5/25/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PlaceMapViewViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic) MKCoordinateRegion region;
@property (nonatomic, strong) NSString *placeName;

@end

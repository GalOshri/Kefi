//
//  PlaceMapViewViewController.m
//  Kefi
//
//  Created by Paul Stavropoulos on 5/25/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "PlaceMapViewViewController.h"

@interface PlaceMapViewViewController ()
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation PlaceMapViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    self.mapView.mapType = MKMapTypeStandard;
    
    // Current location
    [self.mapView setShowsUserLocation:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    // Annotation
    //load default location
    [self.mapView setRegion:self.region animated:YES];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.region.center.latitude, self.region.center.longitude);

    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    //add a marker at point
    [self.mapView addAnnotation:point];
    self.placeLabel.text = self.placeName;
}

/*- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}*/

/*- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    MKCoordinateRegion region;
    region = MKCoordinateRegionMakeWithDistance(self.locationManager.location.coordinate, 1000, 1000);
    
    [mv setRegion:region animated:YES];
}*/


@end

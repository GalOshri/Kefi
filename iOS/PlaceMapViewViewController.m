//
//  PlaceMapViewViewController.m
//  Kefi
//
//  Created by Paul Stavropoulos on 5/25/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "PlaceMapViewViewController.h"

@interface PlaceMapViewViewController ()
@property (weak, nonatomic) IBOutlet UILabel *placeAddress;
@property (weak, nonatomic) IBOutlet UILabel *placeCrossStreets;

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

    [self.mapView setRegion:self.region animated:YES];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.region.center.latitude, self.region.center.longitude);

    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coordinate;
    point.title = self.placeName;

    //add a marker at place
    [self.mapView addAnnotation:point];
    [self.mapView selectAnnotation:point animated:YES];
    
    self.placeAddress.text = self.placeAddressText;
    
    if (![self.placeCrossStreetsText isEqual:@"(null)"])
        self.placeCrossStreets.text = self.placeCrossStreetsText;
    else
        [self.placeCrossStreets setHidden:YES];
}

/*- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}*/

- (IBAction)showDirections:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"http://maps.apple.com/?daddr=%f,%f&saddr=%f,%f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude,self.region.center.latitude, self.region.center.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

@end

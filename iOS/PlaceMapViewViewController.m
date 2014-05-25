//
//  PlaceMapViewViewController.m
//  Kefi
//
//  Created by Paul Stavropoulos on 5/25/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "PlaceMapViewViewController.h"
#import "MapAnnotation.h"

@interface PlaceMapViewViewController ()

@end

@implementation PlaceMapViewViewController
@synthesize mapView;

- (void)viewDidLoad
{
    self.mapView.mapType = MKMapTypeStandard;
     
    //load default location
    [self.mapView setRegion:self.region animated:YES];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.region.center.latitude, self.region.center.longitude);
    
    MapAnnotation *placePin = [[MapAnnotation alloc] initWithCoordinates:coordinate placeName:self.placeName description:nil];
    
    //add a marker at point
    [self.mapView addAnnotation:placePin];
}

-(void)viewDidUnload {
    self.mapView = nil;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    static NSString* myIdentifier = @"myIndentifier";
    MKPinAnnotationView* pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:myIdentifier];
    pinView.pinColor = MKPinAnnotationColorPurple;
    
    if (!pinView)
    {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:myIdentifier];
        pinView.pinColor = MKPinAnnotationColorPurple;
        pinView.animatesDrop = NO;
    }
    return pinView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

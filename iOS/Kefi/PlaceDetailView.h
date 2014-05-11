//
//  PlaceDetailView.h
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Place.h"

@interface PlaceDetailView : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *allView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) Place *place;

@property (weak, nonatomic) IBOutlet UILabel *placeAddress;
@property (weak, nonatomic) IBOutlet UILabel *placeTitle;
@property (weak, nonatomic) IBOutlet UILabel *placeCrossStreets;
@property (weak, nonatomic) IBOutlet UILabel *distanceMi;
//@property (nonatomic, strong) IBOutlet MKMapView *mapView;


@end

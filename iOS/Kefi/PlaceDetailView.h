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
#import "HashtagCollectionCell.h"
#import "HashtagList.h"


@interface PlaceDetailView : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    
}

@property (strong, nonatomic) IBOutlet UIView *allView;

@property (strong, nonatomic) IBOutlet UICollectionView *hashtagView;


//@property (strong, nonatomic) HashtagList *hashtagList;

@property (nonatomic, strong) Place *place;

@property (weak, nonatomic) IBOutlet UILabel *placeAddress;
@property (weak, nonatomic) IBOutlet UILabel *placeCrossStreets;
@property (weak, nonatomic) IBOutlet UILabel *distanceMi;

//@property (nonatomic, strong) IBOutlet MKMapView *mapView;
//@property (weak, nonatomic) IBOutlet UILabel *placeTitle;

@end

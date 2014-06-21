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



@interface PlaceDetailView : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    
}

@property (nonatomic, strong) Place *place;

@property (strong, nonatomic) IBOutlet UICollectionView *hashtagView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

/*
 @property (weak, nonatomic) IBOutlet UILabel *placeAddress;
 @property (weak, nonatomic) IBOutlet UILabel *placeCrossStreets;
*/

-(void)setSentimentImage;

@end

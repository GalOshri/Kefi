//
//  PlaceCell.h
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "place.h"

@interface PlaceCell : UITableViewCell

@property (nonatomic, strong) Place *place;

// UI elements
@property (strong, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UITextView *placeHashtag1;
@property (weak, nonatomic) IBOutlet UITextView *placeHashtag2;
@property (weak, nonatomic) IBOutlet UILabel *placeDistance;
@property (weak, nonatomic) IBOutlet UILabel *placeType;

@property (weak, nonatomic) IBOutlet UIImageView *sentimentImage;
@property (weak, nonatomic) IBOutlet UIImageView *energyLevel1;
@property (weak, nonatomic) IBOutlet UIImageView *energyLevel2;
@property (weak, nonatomic) IBOutlet UIImageView *energyLevel3;

// @property (strong, nonatomic) IBOutlet UIImageView *placeTypeImage;

@end

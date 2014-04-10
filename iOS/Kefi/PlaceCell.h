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
@property (strong, nonatomic) IBOutlet UIImageView *placeTypeImage;
@property (strong, nonatomic) IBOutlet UITextView *placeHashtags;

@end

//
//  ReviewCell.h
//  Kefi
//
//  Created by Gal Oshri on 6/26/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewCell : UITableViewCell

// UI elements
@property (strong, nonatomic) IBOutlet UILabel *placeName;
@property (strong, nonatomic) IBOutlet UITextView *placeHashtags;
@property (weak, nonatomic) IBOutlet UILabel *reviewTime;

@property (weak, nonatomic) IBOutlet UIImageView *sentimentImage;
@property (weak, nonatomic) IBOutlet UIImageView *energyLevel1;
@property (weak, nonatomic) IBOutlet UIImageView *energyLevel2;
@property (weak, nonatomic) IBOutlet UIImageView *energyLevel3;

@end

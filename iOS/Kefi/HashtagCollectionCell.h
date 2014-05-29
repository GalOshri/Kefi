//
//  HashtagCollectionCell.h
//  Kefi
//
//  Created by Paul Stavropoulos on 5/15/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hashtag.h"

@interface HashtagCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIButton *hashtagToggle;
@property (strong, nonatomic) Hashtag *hashtag;
@property (nonatomic) BOOL isSelected;


-(id)setBool:(BOOL)selected;

@end

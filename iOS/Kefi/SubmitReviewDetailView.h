//
//  SubmitReviewDetailView.h
//  Kefi
//
//  Created by Gal Oshri on 5/12/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface SubmitReviewDetailView : UIViewController
@property (nonatomic, strong) Place *place;
@property (nonatomic) int energyLevel;
@property (nonatomic) int sentimentLevel;

@property (strong, nonatomic) IBOutlet UIImageView *sentimentImage;

@property (nonatomic) CGRect imageFrame;
@property (nonatomic) CGRect placeLabelFrame;
@property (nonatomic) CGRect reviewDetailLabelFrame;

@end

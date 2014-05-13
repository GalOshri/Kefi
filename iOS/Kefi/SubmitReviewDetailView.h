//
//  SubmitReviewDetailView.h
//  Kefi
//
//  Created by Gal Oshri on 5/12/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubmitReviewDetailView : UIViewController

@property (nonatomic) int energyLevel;
@property (nonatomic) int sentimentLevel;
@property (strong, nonatomic) IBOutlet UILabel *sentimentLabel;
@property (strong, nonatomic) IBOutlet UILabel *energyLabel;

@property (strong, nonatomic) IBOutlet UIImageView *sentimentImage;

@property (nonatomic) CGRect imageFrame;

@end

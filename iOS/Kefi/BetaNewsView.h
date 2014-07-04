//
//  BetaNewsView.h
//  Kefi
//
//  Created by Gal Oshri on 7/4/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BetaNewsView : UIViewController
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UITextView *betaNewsTextView;

@end

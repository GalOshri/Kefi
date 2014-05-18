//
//  SubmitReviewDetailView.m
//  Kefi
//
//  Created by Gal Oshri on 5/12/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "SubmitReviewDetailView.h"
#import "Place.h"

@interface SubmitReviewDetailView ()

@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (strong, nonatomic) IBOutlet UILabel *reviewDetailLabel;

@end

@implementation SubmitReviewDetailView


#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.reviewDetailLabel.text = [NSString stringWithFormat:@"S: %d  E: %d", self.sentimentLevel, self.energyLevel];
    self.placeLabel.text = self.place.name;
}

// Adjust layout to match previous view
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    NSDictionary *horizontalToSentimentDict = @{@0:@"soPissed.png",
                                                @1:@"eh.png",
                                                @3:@"semiHappy.png",
                                                @4:@"soHappy.png"};
    
    self.placeLabel.frame = self.placeLabelFrame;
    self.reviewDetailLabel.frame = self.reviewDetailLabelFrame;
    
    self.placeLabel.textAlignment = NSTextAlignmentCenter;
    self.reviewDetailLabel.textAlignment = NSTextAlignmentCenter;

    
    self.sentimentImage.frame = self.imageFrame;
    self.sentimentImage.image = [UIImage imageNamed:[horizontalToSentimentDict objectForKey:[NSNumber numberWithInt:self.sentimentLevel]]];
    
    
    //animate placeName and reviewdetail labels down
    
    [UIView animateWithDuration:0.5 animations:^{
        self.placeLabel.center = CGPointMake(self.view.center.x , self.sentimentImage.frame.origin.y + 17);
        self.reviewDetailLabel.center = CGPointMake(self.view.center.x, self.placeLabel.frame.origin.y + 35);
    }];
    
}

#pragma mark - Submission Methods

- (IBAction)submitReview:(UIButton *)sender {
    // Update place's sentiment and energy
    [self.place submitSentiment:self.sentimentLevel];
    [self.place submitEnergy:self.energyLevel];
    [self.place updateLastReviewTime];
    
    // Address hashtags
    NSArray *hashtags = @[@"BeenHereDoneThat", @"Ain'tNobodyGotTimeForThis", @"LustyIntentions", @"CasualBlackout"];
    bool isExisting;
    
    for (NSString *hashtagString in hashtags)
    {
        isExisting = NO;
        // Address existing hashtags
        for (Hashtag *existingHashtag in self.place.hashtagList)
        {
            if ([existingHashtag.text isEqualToString:hashtagString])
            {
                [existingHashtag addReview];
                isExisting = YES;
                break;
            }
        }
        
        // New hashtag
        if (!isExisting)
        {
            [self.place addHashtag:hashtagString];
        }
    }
}


@end

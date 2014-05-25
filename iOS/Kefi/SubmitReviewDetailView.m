//
//  SubmitReviewDetailView.m
//  Kefi
//
//  Created by Gal Oshri on 5/12/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "SubmitReviewDetailView.h"
#import "Place.h"
#import "KefiService.h"


@interface SubmitReviewDetailView ()

@property (strong, nonatomic) IBOutlet UILabel *placeLabel;


@property (weak, nonatomic) IBOutlet UIImageView *firstEnergyCircle;
@property (weak, nonatomic) IBOutlet UIImageView *secondEnergyCircle;
@property (weak, nonatomic) IBOutlet UIImageView *thirdEnergyCircle;
@property (strong, nonatomic) IBOutlet UILabel *reviewDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelBUtton;

@property (nonatomic, strong) KefiService *kefiService;

@end

@implementation SubmitReviewDetailView


#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.reviewDetailLabel.text = self.reviewDetailLabelText;
    self.placeLabel.text = self.place.name;
    [self.placeLabel sizeToFit];
    self.placeLabel.textAlignment = NSTextAlignmentLeft;
    self.reviewDetailLabel.textAlignment = NSTextAlignmentLeft;
}

// Adjust layout to match previous view
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    NSDictionary *horizontalToSentimentDict = @{@0:@"soPissed.png",
                                                @1:@"eh.png",
                                                @3:@"semiHappy.png",
                                                @4:@"soHappy.png"};
    
    NSArray *energyLevels = @[self.firstEnergyCircle, self.secondEnergyCircle, self.thirdEnergyCircle];
    
    
    self.placeLabel.frame = self.placeLabelFrame;
    self.reviewDetailLabel.frame = self.reviewDetailLabelFrame;

    self.sentimentImage.frame = self.imageFrame;
    self.sentimentImage.image = [UIImage imageNamed:[horizontalToSentimentDict objectForKey:[NSNumber numberWithInt:self.sentimentLevel]]];
    
    
    //animate placeName and reviewdetail labels down
    
    [UIView animateWithDuration:0.5 animations:^{
        self.placeLabel.frame = CGRectMake(self.sentimentImage.frame.origin.x + self.sentimentImage.frame.size.width + 15, self.sentimentImage.frame.origin.y, self.placeLabel.frame.size.width, self.placeLabel.frame.size.height);
        
        self.reviewDetailLabel.frame = CGRectMake(self.placeLabel.frame.origin.x, self.placeLabel.frame.origin.y + 15, self.reviewDetailLabel.frame.size.width, self.reviewDetailLabel.frame.size.height);
    }completion:^(BOOL finished){
        //change label to energy levels
        for (int count = 0; count < 3; count++){
            UIImageView *imageView = [energyLevels objectAtIndex:count];
            
            if (self.energyLevel > count) {
                [imageView setImage:[UIImage imageNamed:@"smallCircleFull.png"]];
            }
            
            else
                [imageView setImage:[UIImage imageNamed:@"smallCircle.png"]];
            
            //position circles and make label disappear
            imageView.frame = CGRectMake(count * 40 + self.reviewDetailLabel.frame.origin.x, self.reviewDetailLabel.frame.origin.y + 10, imageView.frame.size.width, imageView.frame.size.height);
            
            
            //hide or unhide things
            [self.reviewDetailLabel setHidden:YES];
            [self.cancelBUtton setHidden:NO];
            [self.submitButton setHidden:NO];

        }
        
    }];

    
}

#pragma mark - Submission Methods

- (IBAction)submitReview:(UIButton *)sender {
    // Update place's sentiment and energy
    [self.place submitSentiment:self.sentimentLevel];
    [self.place submitEnergy:self.energyLevel];
    [self.place updateLastReviewTime];
    
    //Add hashtags to client side view
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

    [KefiService AddReviewforPlace:self.place withSentiment:self.sentimentLevel withEnergy:self.energyLevel withHashtagStrings:hashtags];
    
}


@end

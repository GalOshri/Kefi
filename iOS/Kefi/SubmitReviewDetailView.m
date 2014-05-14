//
//  SubmitReviewDetailView.m
//  Kefi
//
//  Created by Gal Oshri on 5/12/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "SubmitReviewDetailView.h"

@interface SubmitReviewDetailView ()
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (strong, nonatomic) IBOutlet UILabel *reviewDetailLabel;
@end

@implementation SubmitReviewDetailView



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    NSDictionary *horizontalToSentimentDict = @{@0:@"soPissed.png",
                                                @1:@"eh.png",
                                                @3:@"semiHappy.png",
                                                @4:@"soHappy.png"};
    
    NSLog(@"%f   %f   %f    %f", self.imageFrame.origin.x, self.imageFrame.origin.y, self.imageFrame.size.height, self.imageFrame.size.width);
    self.sentimentImage.frame = self.imageFrame;
    self.sentimentImage.image = [UIImage imageNamed:[horizontalToSentimentDict objectForKey:[NSNumber numberWithInt:self.sentimentLevel]]];
    
    self.placeLabel.frame = self.placeLabelFrame;
    self.reviewDetailLabel.frame = self.reviewDetailLabelFrame;
    self.reviewDetailLabel.textAlignment = NSTextAlignmentCenter;
    
    //animate placeName and reviewdetail labels down and to the left
    
    [UIView animateWithDuration:0.5 animations:^{
        self.placeLabel.center = CGPointMake(self.view.center.x , self.sentimentImage.frame.origin.y + 17);
        self.reviewDetailLabel.center = CGPointMake(self.view.center.x, self.placeLabel.frame.origin.y + 35);
        self.reviewDetailLabel.text = [NSString stringWithFormat:@"S: %d  E: %d", self.sentimentLevel, self.energyLevel];
        //self.placeLabel.textAlignment = NSTextAlignmentLeft;
        //self.reviewDetailLabel.textAlignment = NSTextAlignmentLeft;
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

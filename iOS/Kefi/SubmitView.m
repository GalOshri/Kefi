//
//  SubmitView.m
//  Kefi
//
//  Created by Gal Oshri on 4/13/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "SubmitView.h"
#import "SubmitReviewDetailView.h"
#import "Place.h"

@interface SubmitView ()


@property (strong, nonatomic) IBOutlet UILabel *coordinateLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (strong, nonatomic) IBOutlet UIButton *moveButton;
@property (strong, nonatomic) IBOutlet UIView *drawView;
@property (strong, nonatomic) IBOutlet UIButton *reviewButton;
@property (weak, nonatomic) IBOutlet UILabel *PlaceName;

@property (weak, nonatomic) IBOutlet UIButton *L4Sentiment;
@property (weak, nonatomic) IBOutlet UIButton *L3Sentiment;
@property (weak, nonatomic) IBOutlet UIButton *L2Sentiment;
@property (weak, nonatomic) IBOutlet UIButton *L1Sentiment;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *sentimentCircles;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *L4EnergyCircles;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *L3EnergyCircles;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *L2EnergyCircles;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *L1EnergyCircles;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *Vert1EnergyCircles;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *Vert2EnergyCircles;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *Vert3EnergyCircles;






@end

@implementation SubmitView

    

//globals needed
int numVerticalCells = 5;
int numHorizontalCells = 4;
CGFloat cellWidth;
CGFloat cellHeight;

//needed for finding change
int selectedSentimentIndex = -1;
NSTimer *timer;

int activatedSentiment; // -1 is when nothing is activated
int activatedEnergy; // -1 is when nothing is activated

NSDictionary *horizontalToSentimentDict;
NSDictionary *horizontalToEnergyCirclesDict;
NSDictionary *verticalToEnergyCirclesDict;
NSMutableSet *activatedEnergyCircles;

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SubmitReviewDetailSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[SubmitReviewDetailView class]])
        {
            // Pass information to next view to tell where to place UI elements
            SubmitReviewDetailView *srdv = (SubmitReviewDetailView *)segue.destinationViewController;
 
            srdv.sentimentLevel = activatedSentiment;
            srdv.energyLevel = activatedEnergy;
            
            UIButton *currentButton = [horizontalToSentimentDict objectForKey:[NSNumber numberWithInt:activatedSentiment]];

            srdv.imageFrame = CGRectMake(currentButton.frame.origin.x, currentButton.frame.origin.y + self.drawView.frame.origin.y, currentButton.frame.size.width, currentButton.frame.size.height);
            
            srdv.placeLabelFrame = CGRectMake(self.placeLabel.frame.origin.x, self.placeLabel.frame.origin.y, self.placeLabel.frame.size.width, self.placeLabel.frame.size.height);
            srdv.reviewDetailLabelFrame = CGRectMake(self.coordinateLabel.frame.origin.x, self.coordinateLabel.frame.origin.y, self.coordinateLabel.frame.size.width, self.coordinateLabel.frame.size.height);
            
            srdv.place = self.place;
        }
    }
}

#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    cellWidth = (self.drawView.frame.size.width) / numHorizontalCells;
    cellHeight = (self.drawView.frame.size.height) / numVerticalCells;
    
    // set title
    self.placeLabel.text = self.place.name;
    self.placeLabel.textAlignment = NSTextAlignmentCenter;
    
    
    horizontalToSentimentDict = @{@0:self.L1Sentiment,
                                                @1:self.L2Sentiment,
                                                @3:self.L3Sentiment,
                                                @4:self.L4Sentiment};
    
    horizontalToEnergyCirclesDict = @{@0:self.L1EnergyCircles,
                                      @1:self.L2EnergyCircles,
                                      @3:self.L3EnergyCircles,
                                      @4:self.L4EnergyCircles};
                                      
    verticalToEnergyCirclesDict = @{@1:self.Vert1EnergyCircles,
                                    @2:self.Vert2EnergyCircles,
                                    @3:self.Vert3EnergyCircles};
    
    activatedEnergyCircles = [[NSMutableSet alloc] init];
    
    activatedSentiment = -1;
    activatedEnergy = -1;
    
}

#pragma mark - Button Moving Methods

    
- (IBAction)reviewButtonDragged:(UIButton *)sender forEvent:(UIEvent *)event {
    
    // Which segment are we in?
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.drawView];
    if ((point.x - self.reviewButton.frame.size.width / 2) > 0 &&
        (point.x + self.reviewButton.frame.size.width / 2) < self.drawView.frame.size.width &&
        (point.y - self.reviewButton.frame.size.height / 2) > 0 &&
        (point.y + self.reviewButton.frame.size.height / 2) < self.drawView.frame.size.height)
        sender.center = point;
    int horizontalCellIndex = floor(sender.frame.origin.x / cellWidth);
    int verticalCellIndex = floor((self.drawView.frame.size.height - sender.frame.origin.y) / cellHeight);
    
   // if (horizontalCellIndex == -1)
     //   horizontalCellIndex = 0;
    
    self.coordinateLabel.text = [NSString stringWithFormat:@"e: %d   s: %d",horizontalCellIndex, verticalCellIndex];
    self.coordinateLabel.textAlignment = NSTextAlignmentCenter;
  
    if (activatedSentiment == -1)
    {
        if((115 < sender.frame.origin.x < 165) && (verticalCellIndex != 2) && selectedSentimentIndex != verticalCellIndex)
        {
            [timer invalidate];
            selectedSentimentIndex = verticalCellIndex;
            //start/reset the timer.
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(InitiateReviewEnergyLevels:) userInfo:[NSString stringWithFormat:@"%d",verticalCellIndex] repeats:NO];
        }
    }
    
    else
    {
        if (activatedSentiment != verticalCellIndex)
        {
            // Choose different sentiment
            if (horizontalCellIndex == 0 && verticalCellIndex != 2)
            {
                [self DeactivateSentiment:activatedSentiment];
                [self ActivateSentiment:verticalCellIndex];
            }
            
            // Deactivate all energy circles
            [self DeactivateAllEnergyCircles];
            activatedEnergy = -1;
        }
        
        else
        {
            if (activatedEnergy != horizontalCellIndex)
            {
                [self DeactivateAllEnergyCircles];

                NSArray *vertEnergyCircles = [verticalToEnergyCirclesDict objectForKey:[NSNumber numberWithInt:horizontalCellIndex]];
                
                for (UIButton *energyCircle in vertEnergyCircles)
                {
                    [self ActivateEnergyCircle:energyCircle];
                }
                
                [activatedEnergyCircles addObjectsFromArray:vertEnergyCircles];
                activatedEnergy = horizontalCellIndex;
                
            }
        }
    }
}

-(void)InitiateReviewEnergyLevels:(NSTimer *)timer
{
    NSInteger selectedSentiment = [timer.userInfo integerValue];
    
    if (activatedSentiment != -1)
        return;
    
    [self SlideAllSentimentsLeft:(int)selectedSentiment];
    activatedSentiment = (int)selectedSentiment;
}

- (IBAction)reviewButtonTouchUp:(UIButton *)sender forEvent:(UIEvent *)event {
    
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.drawView];
    if (CGRectContainsPoint(self.drawView.frame, CGPointMake(point.x + self.drawView.frame.origin.x, point.y + self.drawView.frame.origin.y)))
        sender.center = point;
    int horizontalCellIndex = floor(sender.frame.origin.x / cellWidth);
    int verticalCellIndex = floor((self.drawView.frame.size.height - sender.frame.origin.y) / cellHeight);
    
    NSLog(@"hor: %d, ver: %d",horizontalCellIndex,verticalCellIndex);
    
    if (activatedSentiment != -1 && activatedEnergy != -1)
    {
        // TODO: SUBMIT REVIEW
        [self HideAllExceptSentiment:activatedSentiment];
        UIButton *currentButton = [horizontalToSentimentDict objectForKey:[NSNumber numberWithInt:activatedSentiment]];
        [UIView animateWithDuration:0.75 animations:^{
            currentButton.center = CGPointMake(currentButton.center.x, 0);
        }completion:^(BOOL finished){
            [self performSegueWithIdentifier:@"SubmitReviewDetailSegue" sender:self];
 
        }];
        
        [timer invalidate];
        return;
        
    }
    else if (activatedSentiment != -1)
    {
        [self SlideAllSentimentsRight];
        [self resetReviewButton];
    }
    else
    {
        [self resetReviewButton];
    }
    
    [timer invalidate];
    activatedSentiment = -1;
    activatedEnergy = -1;
    
    
 
}

- (void)resetReviewButton
{
    self.reviewButton.center = CGPointMake(self.view.center.x, self.view.center.y - self.drawView.frame.origin.y / 2);
}

#pragma mark - Helper Action Methods

- (void)SlideAllSentimentsLeft:(int)selectedSentiment
{
    [UIView animateWithDuration:0.5 animations:^{
        for (id key in horizontalToSentimentDict)
        {
            UIButton *currentButton = [horizontalToSentimentDict objectForKey:key];
            
            currentButton.center = CGPointMake(currentButton.center.x / 3, currentButton.center.y );
            if ([key integerValue] != selectedSentiment)
                [currentButton setAlpha:0.4];
        }
    }
                     completion:^(BOOL finished) {
                         [self ActivateSentiment:selectedSentiment];
                     }];
    
    activatedSentiment = selectedSentiment;
}

- (void)SlideAllSentimentsRight
{
    [UIView animateWithDuration:0.5 animations:^{
        for (id key in horizontalToSentimentDict)
        {
            UIButton *currentButton = [horizontalToSentimentDict objectForKey:key];
            currentButton.center= CGPointMake(currentButton.center.x * 3, currentButton.center.y );
            [currentButton setAlpha:1];
        }
    }];
    
    activatedSentiment = -1;
    for (id key in horizontalToSentimentDict)
    {
        [self DeactivateEnergyLevel:[key intValue]];
    }
}

- (void)ActivateSentiment:(int)sentiment
{
    // TODO: SOME ANIMATION TO ACTIVATE SENTIMENT
    
    activatedSentiment = sentiment;
    
    [UIView animateWithDuration:0.5 animations:^{
        UIButton *currentButton = [horizontalToSentimentDict objectForKey:[NSNumber numberWithInt:sentiment]];
                                   [currentButton setAlpha:1];
                                   }];
        
    [self ActivateEnergyLevel:sentiment];
}

- (void)DeactivateSentiment:(int)sentiment
{
    // TODO: SOME ANIMATION TO DEACTIVATE SENTIMENT
    
    [UIView animateWithDuration:0.5 animations:^{
        UIButton *currentButton = [horizontalToSentimentDict objectForKey:[NSNumber numberWithInt:sentiment]];
                                   [currentButton setAlpha:0.4];
                                   }];
    
    [self DeactivateEnergyLevel:sentiment];
}

- (void)ActivateEnergyLevel:(int)sentiment
{
    // TODO: ADD ANIMATION
    NSArray *energyCircles = [horizontalToEnergyCirclesDict objectForKey:[NSNumber numberWithInteger:sentiment]];
    for (UIButton *energyCircle in energyCircles)
    {
        energyCircle.hidden = NO;
        energyCircle.alpha = 1;
    }
}

- (void)DeactivateEnergyLevel:(int)sentiment
{
    // TODO: ADD ANIMATION
    NSArray *energyCircles = [horizontalToEnergyCirclesDict objectForKey:[NSNumber numberWithInteger:sentiment]];
    for (UIButton *energyCircle in energyCircles)
    {
        energyCircle.hidden = YES;
        energyCircle.alpha = 0;
    }
}

- (void)ActivateEnergyCircle:(UIButton *)energyCircle
{
    [energyCircle setImage:[UIImage imageNamed:@"smallCircleFull.png"] forState:UIControlStateNormal];
}

- (void)DeactivateEnergyCircle:(UIButton *)energyCircle
{
    [energyCircle setImage:[UIImage imageNamed:@"smallCircle.png"] forState:UIControlStateNormal];
}

- (void)DeactivateAllEnergyCircles
{
    for (UIButton *energyCircle in activatedEnergyCircles)
    {
        [self DeactivateEnergyCircle:energyCircle];
    }
    [activatedEnergyCircles removeAllObjects];
}

- (void)HideAllExceptSentiment:(int)sentiment
{
    self.coordinateLabel.hidden = YES;
    self.reviewButton.hidden = YES;
    [self DeactivateEnergyLevel:0];
    [self DeactivateEnergyLevel:1];
    [self DeactivateEnergyLevel:3];
    [self DeactivateEnergyLevel:4];
    for (id key in horizontalToSentimentDict)
    {
        UIButton *currentButton = [horizontalToSentimentDict objectForKey:key];
        
        if ([key integerValue] != sentiment)
            currentButton.hidden = YES;
    }
}


@end

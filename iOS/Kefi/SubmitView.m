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

// @property (weak, nonatomic) IBOutlet UILabel *energyLabel;
@property (strong, nonatomic) IBOutlet UILabel *coordinateLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;
@property (strong, nonatomic) IBOutlet UIView *drawView;
@property (strong, nonatomic) IBOutlet UIButton *reviewButton;

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

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *energyLabels; 

// constraints
/*
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *L4TopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *L3TopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *reviewButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *L2TopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *L1TopConstraint;
*/

@end

@implementation SubmitView

    

//globals needed
int numVerticalCells = 5;
int numHorizontalCells = 4;
CGFloat cellWidth;
CGFloat cellHeight;

// global bools for checking if need to animate sentiments back right
bool isAnimating = NO;
bool slideBackRight = NO;

//needed for finding change
int selectedSentimentIndex = -1;
NSTimer *timer;

int activatedSentiment; // -1 is when nothing is activated
int activatedEnergy; // -1 is when nothing is activated

NSDictionary *horizontalToSentimentDict;
NSDictionary *horizontalToEnergyCirclesDict;
NSDictionary *verticalToEnergyCirclesDict;
NSMutableSet *activatedEnergyCircles;

NSDictionary *sentimentStrings;
NSDictionary *energyStrings;
NSString *coordinateLabelDefault;
NSString *energyLabelDefault;






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
            
            
            srdv.reviewDetailLabelText = self.coordinateLabel.text;
            srdv.reviewDetailLabelCenter = CGPointMake(self.coordinateLabel.center.x, self.coordinateLabel.center.y);
            srdv.place = self.place;
        }
    }
}

#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    // set height of drawView
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    CGRect frame = CGRectMake(self.drawView.frame.origin.x, self.drawView.frame.origin.y, screenWidth, screenHeight - self.drawView.frame.origin.y);
    
    [self.drawView setFrame:frame];
    
    
    cellWidth = (self.drawView.frame.size.width) / numHorizontalCells;
    cellHeight = (self.drawView.frame.size.height) / numVerticalCells;
    
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
    selectedSentimentIndex = -1;
    
    //set dictionaries for coordinateLabel
    //TODO: move server-side
    coordinateLabelDefault = @"";
    energyLabelDefault = @"What's the Vibe?";
    
    sentimentStrings = @{@0:@"Save me!",
                         @1: @"Meh...",
                         @2: coordinateLabelDefault,
                         @3: @"It's fun",
                         @4: @"Love it!"};
    
    energyStrings = @{@0: energyLabelDefault,
                      @1: @"chill",
                      @2: @"buzzin'",
                      @3: @"ragin'!"};


    // hardcode position of sentiment circles
    /*
     // remove constraints
     [self.L4Sentiment removeConstraint:self.L4TopConstraint];
     [self.L3Sentiment removeConstraint:self.L3TopConstraint];
     [self.L2Sentiment removeConstraint:self.L2TopConstraint];
     [self.L1Sentiment removeConstraint:self.L1TopConstraint];
     [self.reviewButton removeConstraint:self.reviewButtonTopConstraint];
     
     //add constraints
     NSLayoutConstraint *L4NewConstraint = [NSLayoutConstraint constraintWithItem:self.L4Sentiment attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.drawView attribute:NSLayoutAttributeTop multiplier:0.2 constant:self.drawView.frame.size.height];
     
     NSLayoutConstraint *L3NewConstraint = [NSLayoutConstraint constraintWithItem:self.L3Sentiment attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.drawView attribute:NSLayoutAttributeTop multiplier:0.4 constant:self.drawView.frame.size.height];
     
     [self.drawView addConstraints:@[L4NewConstraint, L3NewConstraint]];
     */
    
}


-(void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // set title
    [self.placeLabel setText: self.place.name];
    [self.placeLabel sizeToFit];
    [self.placeLabel setCenter: CGPointMake(self.view.center.x, 55)];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // set location of sentiment circles.
    for (UIButton *temp in self.sentimentCircles) {
        int index = (int) [self.sentimentCircles indexOfObject:temp];
        
        temp.center = CGPointMake(self.drawView.center.x, (self.drawView.frame.size.height * (((float)index + 1) / (float)numVerticalCells)) - 44);
        
        // grab correct horizontalEnergy from dictionary
        if (index != 2) {
            NSArray *energyCircles = [horizontalToEnergyCirclesDict objectForKey:[NSNumber numberWithInt:4-index]];
            
            for (UIButton *energy in energyCircles)
                energy.center = CGPointMake(energy.center.x, temp.center.y);
        }
    }
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
    
    if (activatedSentiment == -1)
    {
        self.coordinateLabel.text = [NSString stringWithFormat:@"%@",[sentimentStrings objectForKey:[NSNumber numberWithInt:verticalCellIndex]]];
        
        self.coordinateLabel.textAlignment = NSTextAlignmentCenter;

        if((115 < sender.frame.origin.x < 165) && (verticalCellIndex != 2) && selectedSentimentIndex != verticalCellIndex)
        {
            [timer invalidate];
            selectedSentimentIndex = verticalCellIndex;
            //start/reset the timer.
            timer = [NSTimer scheduledTimerWithTimeInterval:0.50 target:self selector:@selector(InitiateReviewEnergyLevels:) userInfo:[NSString stringWithFormat:@"%d",verticalCellIndex] repeats:NO];
        }
    }
    
    else
    {
        // self.coordinateLabel.text = energyLabelDefault;// [NSString stringWithFormat:@"%@",[sentimentStrings objectForKey:[NSNumber numberWithInt:verticalCellIndex]]];
        
        // self.energyLabel.text = [NSString stringWithFormat:@"%@", [energyStrings objectForKey:[NSNumber numberWithInt:horizontalCellIndex]]];
        
        if (activatedSentiment != verticalCellIndex)
        {
            // Choose different sentiment
            if (horizontalCellIndex == 0 && verticalCellIndex != 2)
            {
                [self DeactivateSentiment:activatedSentiment];
                [self ActivateSentiment:verticalCellIndex];
            }
            
            // self.energyLabel.text = @"";
            self.coordinateLabel.text = energyLabelDefault;
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
                
                if (horizontalCellIndex !=0)
                {
                    UILabel *activateEnergylabel = [self.energyLabels objectAtIndex:3-horizontalCellIndex];
                    [activateEnergylabel setTextColor:[UIColor blackColor]];
                }
                
            }
        }
    }
}

-(void)InitiateReviewEnergyLevels:(NSTimer *)timer
{
    NSInteger selectedSentiment = [timer.userInfo integerValue];
    if (activatedSentiment != -1)
        return;
    
    activatedSentiment = (int)selectedSentiment;
    [self SlideAllSentimentsLeft:(int)selectedSentiment];
   
}

- (IBAction)reviewButtonTouchUp:(UIButton *)sender forEvent:(UIEvent *)event {
    
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.drawView];
    if (CGRectContainsPoint(self.drawView.frame, CGPointMake(point.x + self.drawView.frame.origin.x, point.y + self.drawView.frame.origin.y)))
        sender.center = point;
    
    if (activatedSentiment != -1 && activatedEnergy > 0)
    {
        // TODO: SUBMIT REVIEW
        [self HideAllExceptSentiment:activatedSentiment];
        UIButton *currentButton = [horizontalToSentimentDict objectForKey:[NSNumber numberWithInt:activatedSentiment]];
        [UIView animateWithDuration:0.75 animations:^{
            // [self.coordinateLabel setHidden:YES];
            [self.view setBackgroundColor:[UIColor whiteColor]];
            currentButton.center = CGPointMake(currentButton.center.x, 0);
        }completion:^(BOOL finished){
            [self performSegueWithIdentifier:@"SubmitReviewDetailSegue" sender:self];
 
        }];
        
        [timer invalidate];
        return;
        
    }
    
    else if (isAnimating == YES) {
        slideBackRight = YES;
        
    }
    else if (activatedSentiment != -1 && isAnimating == NO)
    {
        [self SlideAllSentimentsRight];
        [self resetReviewButton];
    }
    else if( isAnimating == NO)
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
        isAnimating = YES;
        
        for (id key in horizontalToSentimentDict)
        {
            UIButton *currentButton = [horizontalToSentimentDict objectForKey:key];
            
            currentButton.center = CGPointMake(currentButton.center.x / 3, currentButton.center.y );
            if ([key integerValue] != selectedSentiment)
                [currentButton setAlpha:0.4];
        }
        
        // self.coordinateLabel.frame = CGRectMake(self.drawView.frame.origin.x, self.coordinateLabel.frame.origin.y, self.coordinateLabel.frame.size.width, self.coordinateLabel.frame.size.height);
    }
        completion:^(BOOL finished) {
            if (!slideBackRight) {
                [self ActivateSentiment:selectedSentiment];
                // [self.energyLabel setHidden:NO];
                // self.energyLabel.text = energyLabelDefault;
            }
            else {
                [self SlideAllSentimentsRight];
                    [self resetReviewButton];
            }
                         
            isAnimating = NO;
            slideBackRight = NO;
        }];
}

- (void)SlideAllSentimentsRight
{
    [UIView animateWithDuration:0.5 animations:^{
        // [self.energyLabel setHidden:YES];
        for (id key in horizontalToSentimentDict)
        {
            UIButton *currentButton = [horizontalToSentimentDict objectForKey:key];
            currentButton.center= CGPointMake(currentButton.center.x * 3, currentButton.center.y );
            [currentButton setAlpha:1];
        }
        
        self.coordinateLabel.center = CGPointMake(self.drawView.center.x, self.coordinateLabel.center.y);
    }    completion:^(BOOL finished){
        self.coordinateLabel.text = @"how do you feel?";
    }];
    
    activatedSentiment = -1;
    selectedSentimentIndex = -1;
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
        
        int index = (int) [energyCircles indexOfObject:energyCircle];
        
        UILabel *energyLabel = [self.energyLabels objectAtIndex:index];
        [energyLabel setHidden:NO];
        energyLabel.center = CGPointMake(energyCircle.center.x, energyCircle.center.y - 40);
    }
    
    self.coordinateLabel.text = energyLabelDefault;
}

- (void)DeactivateEnergyLevel:(int)sentiment
{
    // TODO: ADD ANIMATION
    NSArray *energyCircles = [horizontalToEnergyCirclesDict objectForKey:[NSNumber numberWithInteger:sentiment]];
    for (UIButton *energyCircle in energyCircles)
    {
        energyCircle.hidden = YES;
        energyCircle.alpha = 0;
        
        int index = (int) [energyCircles indexOfObject:energyCircle];
        
        UILabel *energyLabel = [self.energyLabels objectAtIndex:index];
        [energyLabel setHidden:YES];
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
    
    for (UILabel *energyLabel in self.energyLabels) {
        energyLabel.textColor = [UIColor grayColor];
    }
}

- (void)HideAllExceptSentiment:(int)sentiment
{
    //self.coordinateLabel.hidden = YES;
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

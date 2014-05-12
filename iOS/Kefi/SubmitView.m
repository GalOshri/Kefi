//
//  SubmitView.m
//  Kefi
//
//  Created by Gal Oshri on 4/13/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "SubmitView.h"

@interface SubmitView ()
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
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *Vert4EnergyCircles;





@end

@implementation SubmitView

    

//globals needed
int numVerticalCells = 5;
int numHorizontalCells = 5;
CGFloat cellWidth;
CGFloat cellHeight;

//needed for finding change
int selectedSentimentIndex = -1;
NSTimer *timer;

int activatedSentiment = -1; // -1 is when nothing is activated
int activatedEnergy = -1; // -1 is when nothing is activated

NSDictionary *horizontalToSentimentDict;
NSDictionary *horizontalToEnergyCirclesDict;
NSDictionary *verticalToEnergyCirclesDict;
NSMutableSet *activatedEnergyCircles;


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
    
    cellWidth = (self.drawView.frame.size.width) / numHorizontalCells;
    cellHeight = (self.drawView.frame.size.height) / numVerticalCells;
    
    self.drawView.layer.borderColor = [UIColor blackColor].CGColor;
    self.drawView.layer.borderWidth = 1.0f;

    
    
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
                                    @3:self.Vert3EnergyCircles,
                                    @4:self.Vert4EnergyCircles};
    
    activatedEnergyCircles = [[NSMutableSet alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
- (IBAction)reviewButtonDragged:(UIButton *)sender forEvent:(UIEvent *)event {
    // Where are we
    
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
            // TODO: CHOOSE DIFFERENT SENTIMENT MAYBE
            if (horizontalCellIndex == 0 && verticalCellIndex != 2)
            {
                [self DeactivateSentiment:activatedSentiment];
                [self ActivateSentiment:verticalCellIndex];
            }
            
            // Deactivate all energy circles
            [self DeactivateAllEnergyCircles];
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


@end

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
int numVerticalCells = 4;
int numHorizontalCells = 4;
CGFloat cellWidth;
CGFloat cellHeight;

//needed for finding change
int newSentimentIndex = -1;
int newEnergyIndex = -1;
NSTimer *timer;


bool sentimentsActivated = NO;

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
    
    cellWidth = (self.drawView.frame.size.width - 70) / numHorizontalCells;
    cellHeight = (self.drawView.frame.size.height - 60) / numVerticalCells;
    
    
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
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.drawView];
    if (CGRectContainsPoint(self.drawView.frame, CGPointMake(point.x + self.drawView.frame.origin.x, point.y + self.drawView.frame.origin.y)))
        sender.center = point;
    int horizontalCellIndex = floor(sender.frame.origin.x / cellWidth);
    int verticalCellIndex = floor((self.drawView.frame.size.height - sender.frame.origin.y) / cellHeight);
    
    if (horizontalCellIndex == -1)
        horizontalCellIndex = 0;
    
    self.coordinateLabel.text = [NSString stringWithFormat:@"e: %d   s: %d",horizontalCellIndex, verticalCellIndex];
   
  
    //if 115<frame.origin.x<165 && horizontalcellindex hasn't changed for more than 1 second, and it != 2

    
    // activate correct energy circle if sentiments activated
    if (sentimentsActivated)
    {
        if (newEnergyIndex != horizontalCellIndex)
        {
            newEnergyIndex = horizontalCellIndex;
            for (UIButton *energyCircle in activatedEnergyCircles)
            {
                [energyCircle setImage:[UIImage imageNamed:@"smallCircle.png"] forState:UIControlStateNormal];
            }
            [activatedEnergyCircles removeAllObjects];
            
            if (verticalCellIndex == newSentimentIndex)
            {
                
                NSArray *vertEnergyCircles = [verticalToEnergyCirclesDict objectForKey:[NSNumber numberWithInt:horizontalCellIndex]];
                
                for (UIButton *energyCircle in vertEnergyCircles)
                {
                    [energyCircle setImage:[UIImage imageNamed:@"smallCircleFull.png"] forState:UIControlStateNormal];
                    
                }
                [activatedEnergyCircles addObjectsFromArray:vertEnergyCircles];
            }
        }
    }
    
    // check if we need to activate sentiment
    else
    {
        if((115 < sender.frame.origin.x < 165) && (verticalCellIndex != 2) && newSentimentIndex != verticalCellIndex)
        {
            [timer invalidate];
            newSentimentIndex = verticalCellIndex;
            //start/reset the timer.
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(InitiateReviewEnergyLevels:) userInfo:[NSString stringWithFormat:@"%d",verticalCellIndex] repeats:NO];
        }
    }
}

-(void)InitiateReviewEnergyLevels:(NSTimer *)timer
{
    NSInteger horizontalCellIndex = [timer.userInfo integerValue];
    
    if (sentimentsActivated)
        return;
    

    sentimentsActivated = YES;
    
    //move sentiment objects left
    [UIView animateWithDuration:0.5 animations:^{
        for (id key in horizontalToSentimentDict)
        {
            UIButton *currentButton = [horizontalToSentimentDict objectForKey:key];
            
            currentButton.center = CGPointMake(currentButton.center.x / 3, currentButton.center.y );
            if ([key integerValue] != horizontalCellIndex)
                [currentButton setAlpha:0.4];
        }
    }
    completion:^(BOOL finished) {
         NSArray *energyCircles = [horizontalToEnergyCirclesDict objectForKey:[NSNumber numberWithInteger:horizontalCellIndex]];
         for (UIButton *energyCircle in energyCircles)
         {
             energyCircle.hidden = NO;
             energyCircle.alpha = 1;
         }
     }];
}

- (IBAction)reviewButtonTouchUp:(UIButton *)sender forEvent:(UIEvent *)event {
    
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.drawView];
    if (CGRectContainsPoint(self.drawView.frame, CGPointMake(point.x + self.drawView.frame.origin.x, point.y + self.drawView.frame.origin.y)))
        sender.center = point;
    int horizontalCellIndex = floor(sender.frame.origin.x / cellWidth);
    int verticalCellIndex = floor((self.drawView.frame.size.height - sender.frame.origin.y) / cellHeight);
    
    NSLog(@"hor: %d, ver: %d",horizontalCellIndex,verticalCellIndex);
    
    
    
    [self returnSentimentButtons];
}



- (void)returnSentimentButtons
{
    if (!sentimentsActivated)
        return;
    
    [UIView animateWithDuration:0.5 animations:^{
        for (id key in horizontalToSentimentDict)
        {
            UIButton *currentButton = [horizontalToSentimentDict objectForKey:key];
            currentButton.center= CGPointMake(currentButton.center.x * 3, currentButton.center.y );
            [currentButton setAlpha:1];
        }
        
        for (id key in horizontalToEnergyCirclesDict)
            [self turnOffEnergyLevel:[key integerValue]];
    }];
    sentimentsActivated = NO;
    newSentimentIndex = -1;
}

- (void)turnOffEnergyLevel:(NSInteger)energyLevel
{
    NSArray *energyCircles = [horizontalToEnergyCirclesDict objectForKey:[NSNumber numberWithInteger:energyLevel]];
    for (UIButton *energyCircle in energyCircles)
    {
        energyCircle.hidden = YES;
        energyCircle.alpha = 0;
    }
}



@end

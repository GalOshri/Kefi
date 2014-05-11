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





@end

@implementation SubmitView

    

//globals needed
int numVerticalCells = 4;
int numHorizontalCells = 4;
CGFloat cellWidth;
CGFloat cellHeight;

//needed for finding change
int StillNoChangeIndex = -1;
NSTimer *timer;


//boolean to see if evaluating energy levels
bool evaluatingEnergyLevels = false;


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
    
    /*CGMutablePathRef arc = CGPathCreateMutable();
    CGPathMoveToPoint(arc, NULL,
                      100, 100);
    CGPathAddLineToPoint(arc, NULL, 200, 200);
    CGFloat lineWidth = 10.0;
    CGPathRef strokedArc =
    CGPathCreateCopyByStrokingPath(arc, NULL,
                                   lineWidth,
                                   kCGLineCapButt,
                                   kCGLineJoinMiter, // the default
                                   10); // 10 is default miter limit

    CAShapeLayer *outline = [CAShapeLayer layer];
    outline.fillColor = [UIColor lightGrayColor].CGColor;
    outline.strokeColor = [UIColor blackColor].CGColor;
    outline.lineWidth = 1.0;
    outline.path = strokedArc; // the path we created above
    
    [self.view.layer addSublayer: outline]; */
    
    cellWidth = (self.drawView.frame.size.width - 70) / numHorizontalCells;
    cellHeight = (self.drawView.frame.size.height - 60) / numVerticalCells;
    
    
    self.drawView.layer.borderColor = [UIColor blackColor].CGColor;
    self.drawView.layer.borderWidth = 1.0f;
    
    //set circle Buttons to hidden on load
    [self.L1EnergyCircles setValue:[NSNumber numberWithBool:YES] forKey:@"hidden"];
    [self.L2EnergyCircles setValue:[NSNumber numberWithBool:YES] forKey:@"hidden"];
    [self.L3EnergyCircles setValue:[NSNumber numberWithBool:YES] forKey:@"hidden"];
    [self.L4EnergyCircles setValue:[NSNumber numberWithBool:YES] forKey:@"hidden"];
    
    //tie all of the sentiment circles with ID's
    [self.L1Sentiment setTag:1];
    [self.L2Sentiment setTag:2];
    [self.L3Sentiment setTag:3];
    [self.L4Sentiment setTag:4];
    
    [self.L1EnergyCircles setValue:@(5) forKey:@"tag"];
    [self.L2EnergyCircles setValue:@(6) forKey:@"tag"];
    [self.L3EnergyCircles setValue:@(7) forKey:@"tag"];
    [self.L4EnergyCircles setValue:@(8) forKey:@"tag"];

    
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
   
    //check if person has submitted a review
    //if 115<frame.origin.x<165 && horizontalcellindex hasn't changed for more than 1 second, and it != 2
    if((115 < sender.frame.origin.x < 165) && (verticalCellIndex != 2) && StillNoChangeIndex != verticalCellIndex)
    {
        [timer invalidate];
        StillNoChangeIndex = verticalCellIndex;
        //start/reset the timer.
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(InitiateReviewEnergyLevels:) userInfo:[NSString stringWithFormat:@"%d",verticalCellIndex] repeats:NO];
    }
}

-(void)InitiateReviewEnergyLevels:(NSTimer *)timer
{
    NSInteger horizontalCellIndex = [timer.userInfo integerValue];

    
    if (evaluatingEnergyLevels == false)
    {
        evaluatingEnergyLevels = true;
    
        //move sentiment objects left
        for (int i=1; i<5; i++)
        {
            UIButton *currentButton = (UIButton *) [self.view viewWithTag:i];
            [UIView animateWithDuration:0.5 animations:^{currentButton.center= CGPointMake(currentButton.frame.origin.x/3, currentButton.frame.origin.y+30);}];
            
            
            if (currentButton.tag != horizontalCellIndex)
                //change imate
                [currentButton setAlpha:0.4];
            else
            {
              //  NSArray *energyCircles = (NSArray(UIButton *))[self.view viewWithTag:i+4];
             //   NSLog(@"energy circle is \n %@", energyCircles);
             //   [energyCircles setValue: @(NO) forKey:@"hidden"];
            }
        }
  
    }
}

@end

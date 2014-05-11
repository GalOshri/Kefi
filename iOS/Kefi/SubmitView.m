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

@end

@implementation SubmitView

    


int numVerticalCells = 4;
int numHorizontalCells = 4;
CGFloat cellWidth;
CGFloat cellHeight;

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
    
    cellWidth = self.drawView.frame.size.width / numHorizontalCells;
    cellHeight = self.drawView.frame.size.height / numVerticalCells;
    
    
    self.drawView.layer.borderColor = [UIColor blackColor].CGColor;
    self.drawView.layer.borderWidth = 1.0f;
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
    int horizontalCellIndex = floor(sender.frame.origin.x / cellWidth) + 1;
    int verticalCellIndex = floor((self.drawView.frame.size.height - sender.frame.origin.y) / cellHeight) + 1;
    self.coordinateLabel.text = [NSString stringWithFormat:@"e: %d   s: %d",horizontalCellIndex, verticalCellIndex];
    NSLog(@"%f %f %f %f",point.x, point.y, self.drawView.frame.origin.x, self.drawView.frame.origin.y);
}


    



@end

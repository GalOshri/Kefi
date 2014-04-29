//
//  SubmitView.m
//  Kefi
//
//  Created by Gal Oshri on 4/13/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "SubmitView.h"

@interface SubmitView ()

@end

@implementation SubmitView

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

- (IBAction)realMovingButton:(UIButton *)sender forEvent:(UIEvent *)event {
    CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
    self.moveButton.center = point;
    self.coordinateLabel.text = [NSString stringWithFormat:@"%f",self.moveButton.frame.origin.x];
}


    



@end

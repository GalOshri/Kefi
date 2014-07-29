//
//  FoursquareOAuthViewController.m
//  Kefi
//
//  Created by Paul Stavropoulos on 7/28/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "FoursquareOAuthViewController.h"

@interface FoursquareOAuthViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation FoursquareOAuthViewController

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
    
    
    //
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

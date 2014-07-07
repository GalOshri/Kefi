//
//  KefiLogInView.m
//  Kefi
//
//  Created by Gal Oshri on 6/15/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "KefiLogInView.h"
#import <QuartzCore/QuartzCore.h>

@interface KefiLogInView ()

@end

@implementation KefiLogInView

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
    
    [self.logInView setBackgroundColor:[UIColor blackColor]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Kefi.png"]]];
    CGPoint currentCenter = CGPointMake(self.logInView.logo.center.x, self.logInView.logo.center.y);
    self.logInView.logo.frame = CGRectMake(self.logInView.logo.frame.origin.x, self.logInView.logo.frame.origin.y, 200.0,82.0);
    self.logInView.logo.center = currentCenter;
    
    /*
    // Set buttons appearance
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"exit_down.png"] forState:UIControlStateHighlighted];
    
    [self.logInView.facebookButton setImage:nil forState:UIControlStateNormal];
    [self.logInView.facebookButton setImage:nil forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"facebook_down.png"] forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateHighlighted];
    
    [self.logInView.twitterButton setImage:nil forState:UIControlStateNormal];
    [self.logInView.twitterButton setImage:nil forState:UIControlStateHighlighted];
    [self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
    [self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter_down.png"] forState:UIControlStateHighlighted];
    [self.logInView.twitterButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.twitterButton setTitle:@"" forState:UIControlStateHighlighted];
    */
    
    // [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signup.png"] forState:UIControlStateNormal];
    // [self.logInView.signUpButton setBackgroundColor:[UIColor purpleColor]];
   
    /*
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
    
    
    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0;
    
    // Set field text color
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    */
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [[self.logInView.usernameField layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.logInView.passwordField layer] setBorderColor:[[UIColor grayColor] CGColor]];
    
    [[self.logInView.usernameField layer] setBorderWidth:1.0];
    [[self.logInView.passwordField layer] setBorderWidth:1.0];
    
    [[self.logInView.usernameField layer] setCornerRadius:5.0];
    [self.logInView.usernameField setClipsToBounds:YES];
    
    [[self.logInView.passwordField layer] setCornerRadius:5.0];
    [self.logInView.passwordField setClipsToBounds:YES];
    
    self.logInView.passwordField.frame = CGRectMake(self.logInView.passwordField.frame.origin.x, self.logInView.passwordField.frame.origin.y + 2.0, self.logInView.passwordField.frame.size.width, self.logInView.passwordField.frame.size.height);
    
    // Set frame for elements
 /*   [self.logInView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
    [self.logInView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];
    [self.logInView.facebookButton setFrame:CGRectMake(35.0f, 287.0f, 120.0f, 40.0f)];
    [self.logInView.twitterButton setFrame:CGRectMake(35.0f+130.0f, 287.0f, 120.0f, 40.0f)];
    [self.logInView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    [self.logInView.usernameField setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(35.0f, 195.0f, 250.0f, 50.0f)];
    [self.fieldsBackground setFrame:CGRectMake(35.0f, 145.0f, 250.0f, 100.0f)]; */
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

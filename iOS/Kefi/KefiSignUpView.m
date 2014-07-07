//
//  KefiSignUpView.m
//  Kefi
//
//  Created by Gal Oshri on 6/15/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "KefiSignUpView.h"

@interface KefiSignUpView ()

@end

@implementation KefiSignUpView

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
    
    [self.signUpView setBackgroundColor:[UIColor blackColor]];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Kefi.png"]]];
    CGPoint currentCenter = CGPointMake(self.signUpView.logo.center.x, self.signUpView.logo.center.y);
    self.signUpView.logo.frame = CGRectMake(self.signUpView.logo.frame.origin.x, self.signUpView.logo.frame.origin.y, 200.0,82.0);
    self.signUpView.logo.center = currentCenter;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [[self.signUpView.usernameField layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.signUpView.passwordField layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.signUpView.emailField layer] setBorderColor:[[UIColor grayColor] CGColor]];
    
    [[self.signUpView.usernameField layer] setBorderWidth:1.0];
    [[self.signUpView.passwordField layer] setBorderWidth:1.0];
    [[self.signUpView.emailField layer] setBorderWidth: 1.0];
    
    [[self.signUpView.usernameField layer] setCornerRadius:5.0];
    [self.signUpView.usernameField setClipsToBounds:YES];
    
    [[self.signUpView.passwordField layer] setCornerRadius:5.0];
    [self.signUpView.passwordField setClipsToBounds:YES];
    
    [[self.signUpView.emailField layer] setCornerRadius: 5.0];
    [self.signUpView.emailField setClipsToBounds:YES];
    
    self.signUpView.passwordField.frame = CGRectMake(self.signUpView.passwordField.frame.origin.x, self.signUpView.passwordField.frame.origin.y + 2.0, self.signUpView.passwordField.frame.size.width, self.signUpView.passwordField.frame.size.height);
    
    self.signUpView.emailField.frame = CGRectMake(self.signUpView.emailField.frame.origin.x, self.signUpView.emailField.frame.origin.y + 4.0, self.signUpView.emailField.frame.size.width, self.signUpView.emailField.frame.size.height);
    
    /*  float yOffset = [UIScreen mainScreen].bounds.size.height <= 480.0f ? 30.0f : 0.0f;
    
    CGRect fieldFrame = self.signUpView.usernameField.frame;
    
    [self.signUpView.dismissButton setFrame:CGRectMake(10.0f, 10.0f, 87.5f, 45.5f)];
    [self.signUpView.logo setFrame:CGRectMake(66.5f, 70.0f, 187.0f, 58.5f)];
    [self.signUpView.signUpButton setFrame:CGRectMake(35.0f, 385.0f, 250.0f, 40.0f)];
    [self.fieldsBackground setFrame:CGRectMake(35.0f, fieldFrame.origin.y + yOffset, 250.0f, 174.0f)];
    
    [self.signUpView.usernameField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                       fieldFrame.origin.y + yOffset,
                                                       fieldFrame.size.width - 10.0f,
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.passwordField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                       fieldFrame.origin.y + yOffset,
                                                       fieldFrame.size.width - 10.0f,
                                                       fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.emailField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                    fieldFrame.origin.y + yOffset,
                                                    fieldFrame.size.width - 10.0f,
                                                    fieldFrame.size.height)];
    yOffset += fieldFrame.size.height;
    
    [self.signUpView.additionalField setFrame:CGRectMake(fieldFrame.origin.x + 5.0f,
                                                         fieldFrame.origin.y + yOffset,
                                                         fieldFrame.size.width - 10.0f,
                                                         fieldFrame.size.height)];
   */
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

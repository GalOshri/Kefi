//
//  ContactUsViewController.m
//  Kefi
//
//  Created by Paul Stavropoulos on 6/20/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "ContactUsViewController.h"
#import "KefiService.h"

@interface ContactUsViewController ()
@property (strong, nonatomic) IBOutlet UITextView *feedbackTextView;

@end

@implementation ContactUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.feedbackTextView.delegate = self;
}

- (IBAction)cancelModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)submitFeedback:(id)sender {
    if (self.feedbackTextView.text.length > 0)
    {
        [KefiService submitFeedback:self.feedbackTextView.text];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thanks for the feedback!"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}

- (IBAction)sendFeedbackEmail:(id)sender {
    NSString *urlString = @"mailto:kefiapp@gmail.com?subject=Feedback%20On%20Kefi";
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

@end

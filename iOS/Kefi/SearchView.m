//
//  SearchView.m
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "SearchView.h"

@interface SearchView ()
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation SearchView

# pragma mark - View Load Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
  
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender == self.cancelButton) return;
    if (self.searchTextField.text.length > 0) {
        self.searchTerm = self.searchTextField.text;
    }
}

- (IBAction)finishedSearching:(id)sender {
    [self performSegueWithIdentifier:@"FinishedSearch" sender:self];
}

@end

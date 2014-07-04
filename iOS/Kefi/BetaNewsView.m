//
//  BetaNewsView.m
//  Kefi
//
//  Created by Gal Oshri on 7/4/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "BetaNewsView.h"
#import "KefiService.h"

@interface BetaNewsView ()

@end

@implementation BetaNewsView



- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [KefiService GetBetaNews:self];
}

- (IBAction)cancelModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  PlaceDetailView.m
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "PlaceDetailView.h"
#import "SubmitView.h"

@interface PlaceDetailView ()


@end

@implementation PlaceDetailView

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SubmitReviewSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[SubmitView class]])
        {
            SubmitView *sv = (SubmitView *)segue.destinationViewController;
            //PlaceCell *cell = (PlaceCell *)sender;
            //pdv.place = cell.place;
        }
    }
}

- (IBAction)unwindToPlaceDetail:(UIStoryboardSegue *)segue
{
    SubmitView *source = [segue sourceViewController];
    
}

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
    
    [self.navigationController.viewControllers[self.navigationController.viewControllers.count -1] setTitle:self.place.name];
    //[self.navigationController.viewControllers[self.navigationController.viewControllers.count -2] setTitle:@"Bac"];
    
    // table stuff
    self.tableView.dataSource = self;
//    [self.tableView registerClass:[ContactCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.delegate = self;
    
    self.tableView.sectionHeaderHeight = 0.0f;

    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)favoritePlace:(UIButton *)sender {
}

#pragma mark - Table Protocol Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.place.hashtagList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ident = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
    int index = [indexPath row];
    Hashtag *hashtag = [self.place.hashtagList objectAtIndex:index];
    
    cell.textLabel.text = hashtag.text;
    return cell;
}


@end

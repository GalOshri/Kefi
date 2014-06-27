//
//  UserPageTableViewController.m
//  Kefi
//
//  Created by Paul Stavropoulos on 6/24/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "UserPageTableViewController.h"
#import "SWRevealViewController.h"
#import "ReviewCell.h"
#import "Review.h"
#import "KefiService.h"

@interface UserPageTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profPic;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *lastName;

@property (nonatomic, strong) NSMutableArray *reviewList;

@end

@implementation UserPageTableViewController

# pragma mark - Lazy Instantiations

- (NSMutableArray *)reviewList
{
    if (!_reviewList)
    {
        _reviewList = [[NSMutableArray alloc] init];
    }
    
    return _reviewList;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //picture make circular
    // self.profPic.layer.borderWidth = 3.0f;
    // self.profPic.layer.borderColor = [UIColor grayColor].CGColor;
    
    //set up menu bar
    // Set the side bar button action. When it's tapped, it'll show the menu.
    
    [KefiService PopulateReviews:self.reviewList forUser:[PFUser currentUser] withTable:self.tableView];
}


- (IBAction)cancelModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.reviewList count];
}


- (ReviewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set Dictionary for sentiment picture
    NSDictionary *sentimentToImageDict = @{@100:@"question.png",
                                           @0:@"soPissed.png",
                                           @1:@"eh.png",
                                           @2:@"semiHappy.png",
                                           @3:@"soHappy.png"};
    
    static NSString *CellIdentifier = @"ReviewCell";
    ReviewCell *cell = (ReviewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Set cell

    Review *review = [self.reviewList objectAtIndex:indexPath.row];
    //Place *currentPlace = [self.placeList.places objectAtIndex:indexPath.row];
    cell.placeName.text = @"GALILEO";//cell.place.name;
    
    cell.reviewTime.text = [NSDateFormatter localizedStringFromDate:review.reviewTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
    
    NSString *hashtagText = @"";
    
    for (int i = 0; i < 2; i++)
    {
        if ([review.hashtags count] > i) {
            hashtagText = [hashtagText stringByAppendingFormat:@"#%@\n",[review.hashtags objectAtIndex:i]];
        }
    }
    
    cell.placeHashtags.text = hashtagText;
    cell.placeHashtags.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    cell.placeHashtags.textColor = [UIColor colorWithRed:40.0f/255.0f green:114.0f/255.0f blue:179.0f/255.0f alpha:1.0];
    // cell.placeHashtags.textAlignment = NSTextAlignmentCenter;
    
    // set sentiment / Energy Level and active/inactive states
    //define dictionary:
    NSArray *energyLevels = @[cell.energyLevel1, cell.energyLevel2, cell.energyLevel3];
    
    if(review.sentiment != 100) {
        // NSLog(@"%@ is in Interval: %d with s: %ld, e: %ld", cell.place.name, cell.place.isInInterval, (long)[cell.place.sentiment integerValue], (long)[cell.place.energy integerValue]);
        
        [cell.sentimentImage setHidden:NO];
        cell.sentimentImage.image = [UIImage imageNamed:[sentimentToImageDict objectForKey: [NSNumber numberWithInt:review.sentiment]]];
        
        for (int i = 0; i < [energyLevels count]; i++) {
            [energyLevels[i] setHidden:NO];
            
            UIImageView *imageView = [energyLevels objectAtIndex:i];
            
            if (review.energy > i)
                [imageView setImage:[UIImage imageNamed:@"smallCircleFull.png"]];
            
            else
                [imageView setImage:[UIImage imageNamed:@"smallCircle.png"]];
        }
    }
    
    else {
        [cell.sentimentImage setHidden:NO];
        
        cell.sentimentImage.image = [UIImage imageNamed:[sentimentToImageDict objectForKey:@100]];
        [cell.sentimentImage setAlpha:0.5];
        
        for (int i=0; i<[energyLevels count]; i++) {
            [energyLevels[i] setHidden:NO];
            [energyLevels[i] setImage:[UIImage imageNamed:@"smallCircle.png"]];
        }
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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

//
//  PlaceListView.m
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "PlaceListView.h"
#import "PlaceCell.h"
#import "KefiService.h"
#import "PlaceDetailView.h"
#import "SearchView.h"

#import "Hashtag.h"
#import "KefiLogInView.h"
#import "KefiSignUpView.h"
#import "SWRevealViewController.h"

@interface PlaceListView ()

@property (nonatomic, strong) KefiService *kefiService;
@property (strong, nonatomic) IBOutlet UIButton *cancelSearchButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIScrollView *spotlightView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation PlaceListView {
    CLLocationManager *locationManager;
    NSString *searchTerm;
    NSInteger currentSpotlightTile;
    NSUInteger numSpotlightTiles;
}

# pragma mark - Lazy Instantiations

- (PlaceList *)placeList
{
    if (!_placeList)
    {
        _placeList = [[PlaceList alloc] init];
    }
    
    return _placeList;
}

 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([segue.identifier isEqualToString:@"PlaceDetailSegue"]) {
         if ([segue.destinationViewController isKindOfClass:[PlaceDetailView class]])
         {
             PlaceDetailView *pdv = (PlaceDetailView *)segue.destinationViewController;
             PlaceCell *cell = (PlaceCell *)sender;
             pdv.place = cell.place;
         }
     }
     else if ([segue.identifier isEqualToString:@"SearchSegue"]) {
         if ([segue.destinationViewController isKindOfClass:[SearchView class]])
         {
             // SearchView *pdv = (SearchView *)segue.destinationViewController;
         }
     }
 }

- (IBAction)unwindToList:(UIStoryboardSegue *)segue
{
    SearchView *source = [segue sourceViewController];
    searchTerm = source.searchTerm;
    if (searchTerm != nil)
    {
        if (![searchTerm isEqualToString:@""]) {
            [self.placeList.places removeAllObjects];
            if (locationManager.location != nil)
                [KefiService PopulatePlaceList:self.placeList withTable:self.tableView withSearchTerm:searchTerm withLocation:locationManager.location withSpinner:self.spinner];
            else
                [locationManager startUpdatingLocation];
            
            self.cancelSearchButton.hidden = NO;
        }
    }
}


#pragma mark - View Load Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Log in / sign up if no user signed in
    if (![PFUser currentUser])
    {
        [self showLogInAndSignUpView];
    }
    
    // Change table separators
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    // Set up refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshList)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    // Set up Spotlight
    [self setUpSpotlight];
    
    //searchTerm = @"";
    
    // Set up location manager
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation]; // calls Kefi Service to populate list
    
    // Get settings
    [KefiService GetKefiSettings];
    
    // Set the side bar button action. When it's tapped, it'll show the menu.
    self.menuButton.target = self.revealViewController;
    self.menuButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

- (void)showLogInAndSignUpView
{
    // Create the log in view controller
    KefiLogInView *logInViewController = [[KefiLogInView alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
    [logInViewController setFields: PFLogInFieldsDefault | PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsDismissButton];
    
    
    // Create the sign up view controller
    KefiSignUpView *signUpViewController = [[KefiSignUpView alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
}

- (void)setUpSpotlight
{
    self.spotlightView.delegate = self;
    
    NSArray *imageURLs = [NSArray arrayWithObjects:@"http://newjerseysgottalent.com/wp-content/uploads/2014/04/light_show.jpg", @"http://www.earlybirdsclub.com/wp-content/uploads/2013/03/tumblr_m3om90v9OW1rp7zudo1_500.jpg", @"http://justbartending.com/wp-content/uploads/2012/03/colorful-drinks-625.jpg", nil];
    NSArray *spotlightStrings = [NSArray arrayWithObjects:@"find your scene", @"shots fired", @"welcome to Kefi", nil];
    
    for (int i = 0; i < imageURLs.count; i++) {
        CGRect frame;
        frame.origin.x = self.spotlightView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.spotlightView.frame.size;
        
        // Asynchornous image loading
        NSURLSession *session = [NSURLSession sharedSession];
        UIActivityIndicatorView *spotlightSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spotlightSpinner.center = CGPointMake(frame.origin.x + (frame.size.width / 2.0), frame.origin.y + (frame.size.height / 2.0));
        [self.spotlightView addSubview:spotlightSpinner];
        [spotlightSpinner startAnimating];
        [[session dataTaskWithURL:[NSURL URLWithString:[imageURLs objectAtIndex:i]]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        UIImage *img = [[UIImage alloc] initWithData:data];
                        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
                        imgView.frame = frame;
                        [self.spotlightView addSubview:imgView];
                        [spotlightSpinner stopAnimating];
                        [spotlightSpinner removeFromSuperview];
                        UILabel *imgLabel = [[UILabel alloc] init];
                        imgLabel.frame = CGRectMake(frame.origin.x + 10, frame.origin.y + 88, frame.size.width, 23);
                        imgLabel.text = [spotlightStrings objectAtIndex:i];
                        imgLabel.textColor = [UIColor whiteColor];
                        [self.spotlightView addSubview:imgLabel];
                    }];
                }] resume];
        
        // Synchronous image loading
        /*
         NSURL *url = [NSURL URLWithString:@"http://i.imgur.com/VebP6Ol.jpg"];
         NSData *data = [NSData dataWithContentsOfURL:url];
         UIImage *img = [[UIImage alloc] initWithData:data];
         //UIView *subview = [[UIView alloc] initWithFrame:frame];
         //subview.backgroundColor = [colors objectAtIndex:i];
         //[self.spotlightView addSubview:subview];
         UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
         imgView.frame = frame;
         [self.spotlightView addSubview:imgView]; */
    }
    
    self.spotlightView.contentSize = CGSizeMake(self.spotlightView.frame.size.width * imageURLs.count, self.spotlightView.frame.size.height);
    
    numSpotlightTiles = imageURLs.count;
    currentSpotlightTile = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:4.0f
                                     target:self
                                   selector:@selector(scrollSpotlight:)
                                   userInfo:nil
                                    repeats:YES];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self.tableView reloadData];
}

#pragma mark - Search Methods
- (IBAction)searchCancelClick:(UIButton *)sender
{
    self.cancelSearchButton.hidden = YES;
    [self.placeList.places removeAllObjects];
    if (locationManager.location != nil)
        [KefiService PopulatePlaceList:self.placeList withTable:self.tableView withLocation:locationManager.location withSpinner:self.spinner];
    else
        [locationManager startUpdatingLocation];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.placeList.places count];
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125.00;
            
}

- (PlaceCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set Dictionary for sentiment picture
    NSDictionary *sentimentToImageDict = @{@100:@"question.png",
                                           @0:@"soPissed.png",
                                           @1:@"eh.png",
                                           @2:@"semiHappy.png",
                                           @3:@"soHappy.png"};
    
    static NSString *CellIdentifier = @"PlaceCell";
    PlaceCell *cell = (PlaceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Set cell
    Place *currentPlace = [self.placeList.places objectAtIndex:indexPath.row];
    cell.place = currentPlace;
    cell.placeName.text = cell.place.name;

    //display category name and distance
    NSString *distanceString = [cell.place.currentDistance stringValue];
    distanceString = [distanceString substringToIndex:4];
    
    NSString *displayDistance = [NSString stringWithFormat:@" %@ mi", distanceString];
    NSString *displayType = [NSString stringWithFormat:@"%@", cell.place.categoryType];
    
    cell.placeDistance.text = displayDistance;
    cell.placeType.text = displayType;
    
    NSString *hashtagText = @"";
        
    for (int i=0; i<2; i++)
    {
        if ([cell.place.hashtagList count] > i) {
            Hashtag *currentTag = cell.place.hashtagList[i];
            hashtagText = [hashtagText stringByAppendingFormat:@"#%@\n",currentTag.text];
        }
    }
    
    cell.placeHashtags.text = hashtagText;
    cell.placeHashtags.font = [UIFont fontWithName:@"Helvetica Neue" size:12];
    cell.placeHashtags.textColor = [UIColor colorWithRed:40.0f/255.0f green:114.0f/255.0f blue:179.0f/255.0f alpha:1.0];
    // cell.placeHashtags.textAlignment = NSTextAlignmentCenter;
    
    // set sentiment / Energy Level and active/inactive states
    //define dictionary:
    NSArray *energyLevels = @[cell.energyLevel1, cell.energyLevel2, cell.energyLevel3];
    
    if((long)[cell.place.sentiment integerValue] != 100) {
        // NSLog(@"%@ is in Interval: %d with s: %ld, e: %ld", cell.place.name, cell.place.isInInterval, (long)[cell.place.sentiment integerValue], (long)[cell.place.energy integerValue]);

        [cell.sentimentImage setHidden:NO];
        cell.sentimentImage.image = [UIImage imageNamed:[sentimentToImageDict objectForKey: cell.place.sentiment]];
       
        for (int i=0; i<[energyLevels count]; i++) {
            [energyLevels[i] setHidden:NO];
            
            UIImageView *imageView = [energyLevels objectAtIndex:i];
            
            if ([cell.place.energy integerValue]  > i)
                [imageView setImage:[UIImage imageNamed:@"smallCircleFull.png"]];
            
            else
                [imageView setImage:[UIImage imageNamed:@"smallCircle.png"]];
        }
        
        if (cell.place.isInInterval) {
            [cell.sentimentImage setAlpha:1.0];
            
            for (int j=0; j<[energyLevels count]; j++)
                [energyLevels[j] setAlpha:1.0];
        }
        
        else {
            [cell.sentimentImage setAlpha:0.5];
            
            for (int j=0; j<[energyLevels count]; j++)
                [energyLevels[j] setAlpha:0.5];
            
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

// Refresh table on pull down
- (void)refreshList {
    [self.placeList.places removeAllObjects];
    if (locationManager.location != nil)
        [KefiService PopulatePlaceList:self.placeList withTable:self.tableView withLocation:locationManager.location withSpinner:self.spinner];
    else
        [locationManager startUpdatingLocation];
    
    [self.refreshControl endRefreshing];
}

#pragma mark - Location

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        [KefiService PopulatePlaceList:self.placeList withTable:self.tableView withLocation:currentLocation withSpinner:self.spinner];
    }
    
    [locationManager stopUpdatingLocation];
}


#pragma mark - User Identity Views

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Spotlight UI Methods

- (void)scrollSpotlight:(NSTimer *)theTimer {
    
    CGRect frame;
    currentSpotlightTile = (currentSpotlightTile + 1) % numSpotlightTiles;
    
    frame.origin.x = self.spotlightView.frame.size.width * currentSpotlightTile;
    frame.origin.y = 0;
    frame.size = self.spotlightView.frame.size;
    [self.spotlightView scrollRectToVisible:frame animated:YES];
    
    return;
}

#pragma  mark - Segment Control for Nearby or Favorite Places

- (IBAction)segmentChanged:(UISegmentedControl *)sender {
    switch (self.segmentControl.selectedSegmentIndex)
    {
        // Nearby places
        case 0:
            self.cancelSearchButton.hidden = YES;
            [self.placeList.places removeAllObjects];
            if (locationManager.location != nil)
                [KefiService PopulatePlaceList:self.placeList withTable:self.tableView withLocation:locationManager.location withSpinner:self.spinner];
            else
                [locationManager startUpdatingLocation];
            break;
        // Favorites
        case 1:
            self.cancelSearchButton.hidden = YES;
            [self.placeList.places removeAllObjects];
            [KefiService PopulateFavoritePlaceList:self.placeList withTable:self.tableView withLocation:locationManager.location withSpinner:self.spinner];
            break;
        default: 
            break; 
    }
}

@end

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
@property (nonatomic) BOOL populatingPlaceList;
@property (strong, nonatomic) IBOutlet UIImageView *kefiSpotlight;
@property (weak, nonatomic) IBOutlet UIButton *filter;


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
    //[self setUpSpotlight];
    
    //searchTerm = @"";
    
    // Set up location manager
    self.populatingPlaceList = NO;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation]; // calls Kefi Service to populate list
    
    // Get settings
    [KefiService GetKefiSettings:self]; // sets up spotlight
    
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
    [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", @"publish_actions", nil]];
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
    
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSArray *imageURLs = [userData objectForKey:@"spotlightURLs"];
    NSArray *spotlightStrings = [userData objectForKey:@"spotlightCaptions"];
    
    for (int i = 0; i < imageURLs.count; i++) {
        CGRect frame;
        frame.origin.x = self.spotlightView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.spotlightView.frame.size;

        
        // Asynchornous image loading
        NSURLSession *session = [NSURLSession sharedSession];
        //UIActivityIndicatorView *spotlightSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //spotlightSpinner.center = CGPointMake(frame.origin.x + (frame.size.width / 2.0), frame.origin.y + (frame.size.height / 2.0));
        //[self.spotlightView addSubview:spotlightSpinner];
        //[spotlightSpinner startAnimating];
        [[session dataTaskWithURL:[NSURL URLWithString:[imageURLs objectAtIndex:i]]
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        UIImage *img = [[UIImage alloc] initWithData:data];
                        
                        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
                        imgView.frame = frame;
                        [self.spotlightView addSubview:imgView];

                        
                      //  [spotlightSpinner stopAnimating];
                        //[spotlightSpinner removeFromSuperview];
                        UILabel *imgLabel = [[UILabel alloc] init];
                        imgLabel.frame = CGRectMake(frame.origin.x + 12, frame.origin.y + 122, frame.size.width, 23);
                        imgLabel.text = [spotlightStrings objectAtIndex:i];
                        imgLabel.textColor = [UIColor whiteColor];
                        [self.spotlightView addSubview:imgLabel];
                        if (i == 0)
                            [self.kefiSpotlight removeFromSuperview];
                    }];
                }] resume];
    }
    
    self.spotlightView.contentSize = CGSizeMake(self.spotlightView.frame.size.width * imageURLs.count, self.spotlightView.frame.size.height);
    
    numSpotlightTiles = imageURLs.count;
    currentSpotlightTile = 0;
    
    [NSTimer scheduledTimerWithTimeInterval:10.0f
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
    return 132.00;
            
}

- (PlaceCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set Dictionary for sentiment picture
    NSDictionary *sentimentToImageDict = @{@0:@"question.png",
                                           @1:@"soPissed.png",
                                           @2:@"eh.png",
                                           @3:@"semiHappy.png",
                                           @4:@"soHappy.png"};
    
    static NSString *CellIdentifier = @"PlaceCell";
    PlaceCell *cell = (PlaceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Set cell
    Place *currentPlace = [self.placeList.places objectAtIndex:indexPath.row];
    cell.place = currentPlace;
    cell.placeName.text = cell.place.name;

    //display category name and distance
    if (cell.place.currentDistance != nil)
    {
        NSString *distanceString = [cell.place.currentDistance stringValue];
        distanceString = [distanceString substringToIndex:4];
        NSString *displayDistance = [NSString stringWithFormat:@" %@ mi", distanceString];
        cell.placeDistance.text = displayDistance;
    }
    else
        cell.placeDistance.text = @"";
    
    NSString *displayType = [NSString stringWithFormat:@"%@", cell.place.categoryType];
    cell.placeType.text = displayType;
    
    cell.placeHashtag1.text = @"";
    // cell.placeHashtag2.text = @"";
    
    for (int i=0; i<2; i++)
    {
        if ([cell.place.hashtagList count] > i) {
            Hashtag *currentTag = cell.place.hashtagList[i];
            if (i==0){
                cell.placeHashtag1.text =[NSString stringWithFormat:@"#%@",currentTag.text];
                // cell.placeHashtag1.textAlignment = NSTextAlignmentRight;
            }
            else {
                cell.placeHashtag1.text = [NSString stringWithFormat:@"%@    #%@", cell.placeHashtag1.text, currentTag.text];
                // cell.placeHashtag2.textAlignment = NSTextAlignmentRight;
            }
        }
    }
    
    
    // set sentiment / Energy Level and active/inactive states. Define dictionary:
    NSArray *energyLevels = @[cell.energyLevel1, cell.energyLevel2, cell.energyLevel3];
    
    if((long)[cell.place.sentiment integerValue] != 0) {
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

        cell.sentimentImage.image = [UIImage imageNamed:[sentimentToImageDict objectForKey:@0]];
        [cell.sentimentImage setAlpha:0.5];
        
        for (int i=0; i<[energyLevels count]; i++) {
            [energyLevels[i] setHidden:NO];
            [energyLevels[i] setImage:[UIImage imageNamed:@"smallCircle.png"]];
        }
    }
    
    cell.placeHashtag1.textColor = [UIColor colorWithRed:40.0f/255.0f green:114.0f/255.0f blue:179.0f/255.0f alpha:1.0];
    // cell.placeHashtag2.textColor = [UIColor colorWithRed:40.0f/255.0f green:114.0f/255.0f blue:179.0f/255.0f alpha:1.0];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(PlaceCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // declare array of energy levels
    NSArray *energyLevels = @[cell.energyLevel1, cell.energyLevel2, cell.energyLevel3];
    
    if ([cell.placeHashtag1.text isEqualToString:@""])
    {
        cell.sentimentImage.frame = CGRectMake(cell.sentimentImage.frame.origin.x, cell.sentimentImage.frame.origin.y - 15, cell.sentimentImage.frame.size.width, cell.sentimentImage.frame.size.height);
        
        for (int i=0; i<[energyLevels count]; i++) {
            UIImageView *imageView = [energyLevels objectAtIndex:i];
            imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y - 15, imageView.frame.size.width, imageView.frame.size.height);
        }
        
    }
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
    
    if (currentLocation != nil && !self.spinner.isAnimating) {
        self.populatingPlaceList = YES;
        [self.spinner startAnimating];
        [self.placeList.places removeAllObjects];
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
    NSLog(@"%@", error);
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)filterAlert:(id)sender {
    UIAlertView *sortAlert = [[UIAlertView alloc] initWithTitle:@"Sort by" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"distance", @"last tagged", @"sentiment", @"energy", nil];
    
    [sortAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%d", buttonIndex);
    if (buttonIndex != 0) {
        //send to kefi Service sorting method
        [KefiService SortListView:buttonIndex forTable:self.tableView withPlaces:self.placeList withSpinner:self.spinner];
    }
    
}



@end

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

@interface PlaceListView ()

@property (nonatomic, strong) KefiService *kefiService;
@property (strong, nonatomic) IBOutlet UIButton *cancelSearchButton;
@property (strong, nonatomic) UIView *tableHeader;

@end

@implementation PlaceListView {
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *searchTerm;
}

# pragma mark - Lazy Initiations

- (PlaceList *)placeList
{
    if (!_placeList)
    {
        _placeList = [[PlaceList alloc] init];
    }
    
    return _placeList;
}

- (NSMutableArray *)hashtagList
{
    if (!_hashtagList)
    {
        _hashtagList = [[NSMutableArray alloc] init];
    }
    
    return _hashtagList;
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
             SearchView *pdv = (SearchView *)segue.destinationViewController;
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
            [KefiService PopulatePlaceList:self.placeList withTable:self.tableView withSearchTerm:searchTerm];
            self.tableView.tableHeaderView = self.tableHeader;
        }
    }
}


# pragma mark - View Methods

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
    
    //[self.tableView registerClass:[PlaceCell class] forCellReuseIdentifier:@"PlaceCell"];
    
    searchTerm = @"";
    
    self.kefiService = [[KefiService alloc] init];
    
    [KefiService PopulateHashtagList:self.hashtagList];
    
    [KefiService PopulatePlaceList:self.placeList withTable:self.tableView];
    
    
    
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    //[locationManager startUpdatingLocation];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    self.tableHeader = self.tableView.tableHeaderView;
    self.tableView.tableHeaderView = nil;

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}	

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)searchCancelClick:(UIButton *)sender
{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.tableView.tableHeaderView = nil;
                     }
                     completion:^(BOOL finished) {
                         [self.placeList.places removeAllObjects];
                         [KefiService PopulatePlaceList:self.placeList withTable:self.tableView];
                     }];
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

- (PlaceCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlaceCell";
    PlaceCell *cell = (PlaceCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Set cell
    Place *currentPlace = [self.placeList.places objectAtIndex:indexPath.row];
    cell.place = currentPlace;

    cell.placeName.text = cell.place.name;
    cell.placeTypeImage.image = [UIImage imageNamed:@"bar_64.png"];
    
    NSString *hashtagText = @"";
    Hashtag *currentHashtag;
    
    for (int j = 0; j < [currentPlace.hashtagList count]; j++)
    {
        currentHashtag = [currentPlace.hashtagList objectAtIndex:j];
        hashtagText = [hashtagText stringByAppendingFormat:@"#%@   ",currentHashtag.text];
    }
    
   
    
    cell.placeHashtags.text = hashtagText;
    //cell.placeHashtags.textColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
//        longitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
//        latitudeLabel.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    [locationManager stopUpdatingLocation];
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            NSLog(@"%@", [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country]);
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    NSLog(@"\n");
    NSLog(@"\n");
}



@end

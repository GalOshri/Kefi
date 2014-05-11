//
//  PlaceDetailView.m
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "PlaceDetailView.h"
#import "SubmitView.h"
#import "KefiService.h"

@interface PlaceDetailView ()
@property (nonatomic, strong) KefiService *kefiService;

@end

@implementation PlaceDetailView
@synthesize mapView;

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
    
    
    //sets name to view?
    [self.navigationController.viewControllers[self.navigationController.viewControllers.count -1] setTitle:self.place.name];
    //[self.navigationController.viewControllers[self.navigationController.viewControllers.count -2] setTitle:@"Bac"];
    
    // table stuff
    self.tableView.dataSource = self;
//    [self.tableView registerClass:[ContactCell class] forCellReuseIdentifier:@"cell"];
    
    self.tableView.delegate = self;
    
    self.tableView.sectionHeaderHeight = 0.0f;

    
    [self.tableView reloadData];
    
    
    //Kefi Service instance
    self.kefiService = [[KefiService alloc] init];
    
    //this will be a call to get necessary information from Foursquare venue API --> All necessary info is part of Place model now!
    //[KefiService PopulatePlaceDetailView:self.place withPlaceAddress: self.placeAddress withPlaceCrossStreet: self.placeCrossStreets];
    
    
    //set some more variables here
    self.placeAddress.text = self.place.address;
    self.placeCrossStreets.text = self.place.crossStreet;
    
    //modifications to print sigFigs for distance. NEED TO ROUND
    NSString *distanceString = [self.place.currentDistance stringValue];
    distanceString = [distanceString substringToIndex:4];
    self.distanceMi.text = [NSString stringWithFormat:@"%@ mi",distanceString];
    
   /*
    //adjust map
    CLLocationCoordinate2D startCoord;
    startCoord.latitude = [[self.place.latLong objectAtIndex:0] doubleValue];
    startCoord.longitude = [[self.place.latLong objectAtIndex:0] doubleValue];

    MKPointAnnotation *point = [[MKPointAnnotation alloc]init];
    point.coordinate = startCoord;
    [self.mapView addAnnotation:point];
    
    [mapView setRegion:MKCoordinateRegionMakeWithDistance(startCoord, 200, 200) animated:YES];
  */


     
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

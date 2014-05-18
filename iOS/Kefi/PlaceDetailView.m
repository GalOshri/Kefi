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
//@synthesize mapView;

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SubmitReviewSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[SubmitView class]])
        {
            SubmitView *sv = (SubmitView *)segue.destinationViewController;
            sv.place = self.place;
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
    /*self.tableView.dataSource = self;
    //[self.tableView registerClass:[ContactCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.sectionHeaderHeight = 0.0f;
    [self.tableView reloadData];
    */
    
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

    //temporary assignment of hashtagList
    self.place.hashtagList = [@[@"#LustyIntentions",
                     @"#EverythingIsAwesome",
                     @"#DJMyPantsOff",
                     @"GetLucky",
                     @"PackedLikeSardines"] mutableCopy];
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//favorite/unfavorite this place
- (IBAction)favoritePlace:(UIButton *)sender {
    
}

#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.place.hashtagList.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HashtagCollectionCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"hashtagCell"
                                    forIndexPath:indexPath];
    

    long row = [indexPath row];
    
    [myCell.hashtagToggle setTitle:[self.place.hashtagList objectAtIndex: row] forState:UIControlStateNormal];
    
    return myCell;
}

@end

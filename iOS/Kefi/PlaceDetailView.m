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
    // SubmitView *source = [segue sourceViewController];
}

#pragma mark - View Methods

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
    
    _hashtagView.delegate = self;
    _hashtagView.dataSource = self;
    self.hashtagView.backgroundColor = [UIColor whiteColor];

     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//favorite/unfavorite this place
- (IBAction)favoritePlace:(UIButton *)sender {
    
}



#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"number of items: %lu", (unsigned long)self.place.hashtagList.count);
    return self.place.hashtagList.count;
}


#pragma mark - UICollectionView Datasource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HashtagCollectionCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"hashtagCell"
                                    forIndexPath:indexPath];
    

    long row = [indexPath row];
    
    [myCell.hashtagToggle setTitle:[self.place.hashtagList objectAtIndex: row] forState:UIControlStateNormal];
    [myCell.hashtagToggle sizeToFit];
    
    return myCell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //find the hashtag we're trying to size
    UIButton *button = self.place.hashtagList[indexPath.row];

    //set the size and add a border, if we would like.
    CGSize retval = CGSizeMake(button.frame.size.width, button.frame.size.height);
    return retval;
}


- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 10, 5, 10);
}


@end

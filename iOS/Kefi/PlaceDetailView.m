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

    //set some more variables here
    self.placeAddress.text = self.place.address;
    self.placeCrossStreets.text = self.place.crossStreet;
    
    //modifications to print sigFigs for distance. NEED TO ROUND
    NSString *distanceString = [self.place.currentDistance stringValue];
    distanceString = [distanceString substringToIndex:4];
    self.distanceMi.text = [NSString stringWithFormat:@"%@ mi",distanceString];
    


    //temporary assignment of hashtagList. Right now, there are two hashtags. Add some more.
    Hashtag *hashtag3 = [[Hashtag alloc] initWithText: @"HowYouLikeThemApples"];
    Hashtag *hashtag4 = [[Hashtag alloc] initWithText: @"LustyIntentions"];
    Hashtag *hashtag5 = [[Hashtag alloc] initWithText: @"TurnUp"];
    Hashtag *hashtag6 = [[Hashtag alloc] initWithText: @"IsThatMyMom?"];
    Hashtag *hashtag7 = [[Hashtag alloc] initWithText: @"That'sNO"];
    Hashtag *hashtag8 = [[Hashtag alloc] initWithText: @"CasualBlackout"];
    
    [self.place.hashtagList addObject:hashtag3];
    [self.place.hashtagList addObject:hashtag4];
    [self.place.hashtagList addObject:hashtag5];
    [self.place.hashtagList addObject:hashtag6];
    [self.place.hashtagList addObject:hashtag7];
    [self.place.hashtagList addObject:hashtag8];

    
    self.hashtagView.backgroundColor = [UIColor whiteColor];
    //self.hashtagView.scrollEnabled = NO;

    
    
    //[self.navigationController.viewControllers[self.navigationController.viewControllers.count -2] setTitle:@"Bac"];
    
    // table stuff
    /*self.tableView.dataSource = self;
     //[self.tableView registerClass:[ContactCell class] forCellReuseIdentifier:@"cell"];
     self.tableView.delegate = self;
     self.tableView.sectionHeaderHeight = 0.0f;
     [self.tableView reloadData];
     */
    
    //Kefi Service instance
    //self.kefiService = [[KefiService alloc] init];
    
    //this will be a call to get necessary information from Foursquare venue API --> All necessary info is part of Place model now!
    //[KefiService PopulatePlaceDetailView:self.place withPlaceAddress: self.placeAddress withPlaceCrossStreet: self.placeCrossStreets];
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



//favorite/unfavorite this place
- (IBAction)favoritePlace:(UIButton *)sender {
    
}



#pragma mark Collection View Methods

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    //always 1 section
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
    
    Hashtag *temp = self.place.hashtagList[indexPath.row];
    
    UIButton *button = (UIButton *)[myCell viewWithTag:100];
    
    //set button text and assign to hashtagToggle
    [button setTitle:temp.text forState:UIControlStateNormal];
 
    myCell.hashtagToggle = button;
    
    //play with cells
    [myCell.layer setBorderWidth:2];
    [myCell.layer setBorderColor:[UIColor grayColor].CGColor];
    [myCell.layer setCornerRadius:10];
    

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

/*#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Hashtag *temp = self.place.hashtagList[indexPath.row];
    
    //find the hashtag we're trying to size
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:temp.text forState:UIControlStateNormal];

    //set the size and add a border, if we would like.
    CGSize retval = CGSizeMake(button.frame.size.width, button.frame.size.height);
    NSLog(@"done with setting button/text size..");
    return retval;
}
*/


@end

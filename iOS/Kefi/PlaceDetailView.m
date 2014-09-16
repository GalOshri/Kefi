//
//  PlaceDetailView.m
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "PlaceDetailView.h"
#import "SubmitView.h"
#import "SubmitReviewDetailView.h"
#import "KefiService.h"
#import "PlaceMapViewViewController.h"

@interface PlaceDetailView ()
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (nonatomic) BOOL isFavorite;
@property (strong, nonatomic) IBOutlet UIButton *favoriteButton;

@property (weak, nonatomic) IBOutlet UIImageView *sentimentImage;
@property (weak, nonatomic) IBOutlet UIImageView *energyLevel1;
@property (weak, nonatomic) IBOutlet UIImageView *energyLevel2;
@property (weak, nonatomic) IBOutlet UIImageView *energyLevel3;
@property (weak, nonatomic) IBOutlet UIImageView *venueTypeImg;
@property (weak, nonatomic) IBOutlet UILabel *venueType;
@property (weak, nonatomic) IBOutlet UILabel *noTagLabel;
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
            sv.place = self.place;
        }
    }

    if ([segue.identifier isEqualToString:@"mapViewSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[PlaceMapViewViewController class]])
        {
            PlaceMapViewViewController *pdmv = (PlaceMapViewViewController *) segue.destinationViewController;
            
            MKCoordinateRegion startCoord;
            startCoord.center.latitude = [[self.place.latLong objectAtIndex:0] doubleValue];
            startCoord.center.longitude = [[self.place.latLong objectAtIndex:1] doubleValue];
            startCoord.span.latitudeDelta = 0.02;
            startCoord.span.longitudeDelta = 0.02;
            
            
            pdmv.region = startCoord;
            pdmv.placeName = self.place.name;
            pdmv.placeAddressText = self.place.address;
            pdmv.placeCrossStreetsText = self.place.crossStreet;
        }
    }

}

- (IBAction)unwindToPlaceDetail:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[SubmitReviewDetailView class]]) {
        SubmitReviewDetailView *srdv = segue.sourceViewController;
        // if the user clicked Cancel, we don't want to change the color
        if (srdv.selectedHashtagStrings != nil) {
            [KefiService AddReviewforPlace:self.place withSentiment:srdv.sentimentLevel withEnergy:srdv.energyLevel withHashtagStrings:srdv.selectedHashtagStrings withPlaceDetailView:self];
            
            if (self.place.hashtagList.count > 0)
                [self.noTagLabel setHidden:YES];
        }
    }
}

#pragma mark - View Load Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:32.0/256 green:32.0/256 blue:32.0/256 alpha:1.0]];
    
    
    //sets name to view?
    [self.navigationController.viewControllers[self.navigationController.viewControllers.count -1] setTitle:self.place.name];
    
    //set some more variables here
    self.placeAddress.text = self.place.address;
    
    self.hashtagView.backgroundColor = [UIColor whiteColor];
    
    //map rounded edges
    self.mapButton.layer.cornerRadius = self.mapButton.frame.size.width / 2;
    self.mapButton.clipsToBounds = YES;
    
    // load sentiment/energy images
    [self setSentimentImage];

    self.hashtagView.delegate = self;
    self.hashtagView.dataSource = self;
    
    if (self.place.hashtagList.count <= 0)
        [self.noTagLabel setHidden:NO];
    else
        [self.noTagLabel setHidden:YES];
}

- (void)viewDidLayoutSubviews
{
    [self.hashtagView setBackgroundColor:[UIColor colorWithRed:32.0/256 green:32.0/256 blue:32.0/256 alpha:1.0]];
    
    if ([KefiService isFavorite:self.place.fsId])
    {
        self.isFavorite = YES;
        [self.favoriteButton setImage:[UIImage imageNamed:@"FavFilled.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.favoriteButton setImage:[UIImage imageNamed:@"FavUnfilled.png"] forState:UIControlStateNormal];
        self.isFavorite = NO;
    }
    
    //modifications to print sigFigs for distance. NEED TO ROUND
    if (self.place.currentDistance != nil)
    {
        NSString *distanceString = [self.place.currentDistance stringValue];
        distanceString = [distanceString substringToIndex:4];
        self.distanceLabel.text = [NSString stringWithFormat:@"%@ mi",distanceString];
    }
    else
    {
        self.distanceLabel.text = @"";
    }
    
    if (self.place.hashtagList.count <= 0) {
        [self.noTagLabel setHidden:NO];
        [self.hashtagView setHidden:YES];
    }
    else
        [self.hashtagView setHidden:NO];
    
    //deal with UI showing crossStreets if not null
    if (![self.place.crossStreet isEqual:@"(null)"])
        self.placeCrossStreets.text = self.place.crossStreet;
    else
        self.placeCrossStreets.hidden = YES;
    
    //set venue Type and image type
    self.venueType.text = self.place.categoryType;
    [self.venueTypeImg setImage:self.place.imageType];
}


-(void)setSentimentImage {
    // TODO: move this dictionary to a better place
    // define sentiment level dictionary
    // set Dictionary/arrays for sentiment/energy
    NSDictionary *sentimentToImageDict = @{@0:@"question.png",
                                           @1:@"soPissed.png",
                                           @2:@"eh.png",
                                           @3:@"semiHappy.png",
                                           @4:@"soHappy.png"};
    
    NSArray *energyLevels = @[self.energyLevel1, self.energyLevel2, self.energyLevel3];
    
    
    // set sentiment/energy images
    if ((long)[self.place.sentiment integerValue] != 0) {
        [self.sentimentImage setHidden:NO];
        
        self.sentimentImage.image = [UIImage imageNamed:[sentimentToImageDict objectForKey: self.place.sentiment]];
        
        for (int i=0; i<[energyLevels count]; i++) {
            
            UIImageView *imageView = [energyLevels objectAtIndex:i];
            
            if ([self.place.energy integerValue]  > i)
                [imageView setImage:[UIImage imageNamed:@"smallCircleFull.png"]];
            
            else
                [imageView setImage:[UIImage imageNamed:@"smallCircle.png"]];
        }
        
        if (self.place.isInInterval) {
            [self.sentimentImage setAlpha:1.0];
            
            for (int j=0; j<[energyLevels count]; j++) {
                [energyLevels[j] setAlpha:1.0];
            }
            
        }
    }
    
    else {
        [self.sentimentImage setHidden:NO];
        self.sentimentImage.image = [UIImage imageNamed:[sentimentToImageDict objectForKey:@0]];
        
        for (int i=0; i<[energyLevels count]; i++) {
            [energyLevels[i] setHidden:NO];
            [energyLevels[i] setImage:[UIImage imageNamed:@"smallCircle.png"]];
        }
    }
    
}

#pragma mark - Actions

// Favorite/unfavorite this place
- (IBAction)favoritePlace:(UIButton *)sender {
    
    if (self.isFavorite)
    {
        [KefiService removeFavorite:self.place.fsId];
        [self.favoriteButton setImage:[UIImage imageNamed:@"FavUnfilled.png"] forState:UIControlStateNormal];
        self.isFavorite = NO;
    }
    
    else
    {
        [KefiService addFavorite:self.place];
        [self.favoriteButton setImage:[UIImage imageNamed:@"FavFilled.png"] forState:UIControlStateNormal];
        self.isFavorite = YES;
    }
}

// Go to Foursquare page
- (IBAction)clickFoursquareLink:(UIButton *)sender {
    NSString *urlString = [NSString stringWithFormat:@"http://foursquare.com/v/%@?ref=T4XPWMEQAID11W0CSQLCP2P0NXGEUSDZRV4COSBJH2QEMC2O", self.place.fsId];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
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
    return self.place.hashtagList.count;
}


#pragma mark - UICollectionView Datasource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HashtagCollectionCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"hashtagCell"
                                    forIndexPath:indexPath];
    
    Hashtag *hashtag = self.place.hashtagList[indexPath.row];
    NSString *temp = hashtag.text;
    
    [myCell.textLabel setText:temp];
    [myCell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [myCell.textLabel setTextColor: [UIColor whiteColor]];
    
    /* 
    [myCell.layer setBorderWidth:2];
    [myCell.layer setBorderColor:[UIColor blackColor].CGColor];
    [myCell.layer setCornerRadius:10];
    */
    
    return myCell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Hashtag *hashtag = self.place.hashtagList[indexPath.row];
    NSString *temp = hashtag.text;
    UILabel *label = [[UILabel alloc]init];
    
    //set button text and assign to hashtagToggle
    [label setText:temp];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label sizeToFit];
    
    return CGSizeMake(label.frame.size.width + 10, 20);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0; // This is the minimum inter item spacing, can be more
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
    // space between cells on different lines
}





@end

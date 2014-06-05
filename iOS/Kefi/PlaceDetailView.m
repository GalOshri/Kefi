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
#import "PlaceMapViewViewController.h"

@interface PlaceDetailView ()
@property (nonatomic, strong) KefiService *kefiService;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;

@property (weak, nonatomic) IBOutlet UIImageView *sentimentImage;
@property (weak, nonatomic) IBOutlet UIImageView *energyLevel1;
@property (weak, nonatomic) IBOutlet UIImageView *energyLevel2;
@property (weak, nonatomic) IBOutlet UIImageView *energyLevel3;

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
        }
    }

}

- (IBAction)unwindToPlaceDetail:(UIStoryboardSegue *)segue
{
    NSLog(@"unwindtoplacedetail");
    
    // logic for if new submit was done --> target
    [self setSentimentImage];
    
    
}

#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //sets name to view?
    [self.navigationController.viewControllers[self.navigationController.viewControllers.count -1] setTitle:self.place.name];

    //set some more variables here
    self.placeAddress.text = self.place.address;

    // temporary assignment of hashtagList. Right now, there are two hashtags. Add some more.
    /*Hashtag *hashtag3 = [[Hashtag alloc] initWithText: @"HowYouLikeThemApples"];
    Hashtag *hashtag4 = [[Hashtag alloc] initWithText: @"LustyIntentions"];
    Hashtag *hashtag5 = [[Hashtag alloc] initWithText: @"TurnUp"];
    Hashtag *hashtag6 = [[Hashtag alloc] initWithText: @"IsThatMyMom?"];
    Hashtag *hashtag7 = [[Hashtag alloc] initWithText: @"Crickets"];
    Hashtag *hashtag8 = [[Hashtag alloc] initWithText: @"RageMode"];
    
    [self.place.hashtagList addObject:hashtag3];
    [self.place.hashtagList addObject:hashtag4];
    [self.place.hashtagList addObject:hashtag5];
    [self.place.hashtagList addObject:hashtag6];
    [self.place.hashtagList addObject:hashtag7];
    [self.place.hashtagList addObject:hashtag8];*/

    
    self.hashtagView.backgroundColor = [UIColor whiteColor];
    
    //map rounded edges
    CALayer * l = [self.mapButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:7.0];
    
    // load sentiment/energy images
    [self setSentimentImage];
    
}

- (void)viewDidLayoutSubviews
{
    //modifications to print sigFigs for distance. NEED TO ROUND
    NSString *distanceString = [self.place.currentDistance stringValue];
    distanceString = [distanceString substringToIndex:4];
    self.distanceMi.text = [NSString stringWithFormat:@"%@ mi",distanceString];
    
    //deal with UI showing crossStreets if not null
    if (![self.place.crossStreet isEqual:@"(null)"])
        self.placeCrossStreets.text = self.place.crossStreet;
    else
    {
        CGRect moveCrossStreetFrame = CGRectMake(self.placeCrossStreets.frame.origin.x, self.placeCrossStreets.frame.origin.y, self.distanceMi.frame.size.width, self.distanceMi.frame.size.height);
        self.distanceMi.frame = moveCrossStreetFrame;
        self.placeCrossStreets.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//favorite/unfavorite this place
- (IBAction)favoritePlace:(UIButton *)sender {
    
}



-(void)setSentimentImage {
    NSLog(@"setSentimentImage");
    // TODO: move this dictionary to a better place
    // define sentiment level dictionary
    // set Dictionary/arrays for sentiment/energy
    NSDictionary *sentimentToImageDict = @{@"none":@"question.png",
                                           @0:@"soPissed.png",
                                           @1:@"eh.png",
                                           @2:@"semiHappy.png",
                                           @3:@"soHappy.png"};
    
    NSArray *energyLevels = @[self.energyLevel1, self.energyLevel2, self.energyLevel3];
    
    
    // set sentiment/energy images
    if ((long)[self.place.sentiment integerValue] != -1) {
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
        
        self.sentimentImage.image = [UIImage imageNamed:[sentimentToImageDict objectForKey:@"none"]];
        
        for (int i=0; i<[energyLevels count]; i++)
            [energyLevels[i] setHidden:YES];
    }
    
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
    
    Hashtag *temp = self.place.hashtagList[indexPath.row];
    
 //   UIButton *button = (UIButton *)[myCell viewWithTag:100];
    
    //set button text and assign to hashtagToggle
 //   [button setTitle:temp.text forState:UIControlStateNormal];
    
 //   myCell.hashtagToggle = button;
    
    //play with cells

    // button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    /*
    [myCell.layer setBorderWidth:2];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    myCell.textLabel.text = temp.text;
    
    [myCell.layer setBorderWidth:2];
    [myCell.layer setBorderColor:[UIColor grayColor].CGColor];
    [myCell.layer setCornerRadius:10];
    */
    
    return myCell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"hi");
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}



// TODO: SIZING
/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    Hashtag *temp = self.place.hashtagList[indexPath.row];
    UIButton *button = [[UIButton alloc]init];
    
    //set button text and assign to hashtagToggle
    [button setTitle:temp.text forState:UIControlStateNormal];
    button.titleLabel.font =  [UIFont systemFontOfSize:13];
    [button sizeToFit];

    
    return CGSizeMake(button.frame.size.width + 5, 20);
    
} */

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0; // This is the minimum inter item spacing, can be more
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
    // space between cells on different lines
}


@end

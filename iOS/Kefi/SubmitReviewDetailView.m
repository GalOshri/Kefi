//
//  SubmitReviewDetailView.m
//  Kefi
//
//  Created by Gal Oshri on 5/12/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import "SubmitReviewDetailView.h"
#import "Place.h"
#import "KefiService.h"
#import "HashtagCollectionCell.h"


@interface SubmitReviewDetailView ()

@property (strong, nonatomic) IBOutlet UILabel *placeLabel;


@property (weak, nonatomic) IBOutlet UIImageView *firstEnergyCircle;
@property (weak, nonatomic) IBOutlet UIImageView *secondEnergyCircle;
@property (weak, nonatomic) IBOutlet UIImageView *thirdEnergyCircle;
@property (strong, nonatomic) IBOutlet UILabel *reviewDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) NSMutableArray *hashtags;
@property (weak, nonatomic) IBOutlet UITextField *hashtagTextField;


@property (nonatomic, strong) KefiService *kefiService;
@end


@implementation SubmitReviewDetailView


#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // manually change sentiment if greater than 2 to sentiment - 1
    // because our "2" is merely a placeholder and this messes up calculation
    if (self.sentimentLevel > 2)
        self.sentimentLevel -= 1;
    
    self.reviewDetailLabel.text = self.reviewDetailLabelText;
    self.placeLabel.text = self.place.name;
    [self.placeLabel sizeToFit];
    self.placeLabel.textAlignment = NSTextAlignmentLeft;
    self.reviewDetailLabel.textAlignment = NSTextAlignmentLeft;
    
    self.hashtags = [[NSMutableArray alloc] init];
    for (Hashtag *hashtag in self.place.hashtagList)
    {
        [self.hashtags addObject:hashtag.text];
    }
    
    self.hashtagView.delegate = self;
    self.hashtagView.dataSource = self;
    
    self.hashtagView.allowsMultipleSelection = YES;
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewdidappear");
    
    NSDictionary *sentimentToImageDict = @{@0:@"soPissed.png",
                                           @1:@"eh.png",
                                           @2:@"semiHappy.png",
                                           @3:@"soHappy.png"};
    
    NSArray *energyLevels = @[self.firstEnergyCircle, self.secondEnergyCircle, self.thirdEnergyCircle];
    
    
    self.placeLabel.frame = self.placeLabelFrame;
    self.reviewDetailLabel.frame = self.reviewDetailLabelFrame;
    
    self.sentimentImage.frame = self.imageFrame;
    
    self.sentimentImage.image = [UIImage imageNamed:[sentimentToImageDict objectForKey:[NSNumber numberWithInt:self.sentimentLevel]]];
    
    // uicollectionview background color
    self.hashtagView.backgroundColor = [UIColor whiteColor];
    
    
    // animate placeName and reviewdetail labels down
    NSLog(@"animating");
    [UIView animateWithDuration:0.5 animations:^{
        self.placeLabel.frame = CGRectMake(self.sentimentImage.frame.origin.x + self.sentimentImage.frame.size.width + 15, self.sentimentImage.frame.origin.y, self.placeLabel.frame.size.width, self.placeLabel.frame.size.height);
        
        self.reviewDetailLabel.frame = CGRectMake(self.sentimentImage.frame.origin.x, self.sentimentImage.frame.origin.y + 30, self.reviewDetailLabel.frame.size.width, self.reviewDetailLabel.frame.size.height);
        
        
    }completion:^(BOOL finished){
        //change label to energy levels
        if (finished) {

            for (int count = 0; count < 3; count++){
                UIImageView *imageView = [energyLevels objectAtIndex:count];
                
                if (self.energyLevel > count) {
                    [imageView setImage:[UIImage imageNamed:@"smallCircleFull.png"]];
                }
                
                else
                    [imageView setImage:[UIImage imageNamed:@"smallCircle.png"]];
                
                //position circles and make label disappear
                imageView.frame = CGRectMake(count * 40 + self.reviewDetailLabel.frame.origin.x + 10, self.sentimentImage.frame.origin.y + 30, imageView.frame.size.width, imageView.frame.size.height);
                
                [imageView setHidden:NO];
                
            }
            
            //hide or unhide things
            [self.reviewDetailLabel setHidden:YES];
            [self.cancelButton setHidden:NO];
            [self.submitButton setHidden:NO];
        }
    }];
}



#pragma mark - Submission methods
- (IBAction)submitReview:(UIButton *)sender {
     bool isExisting;
    
    NSMutableArray *selectedHashtagStrings = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in [self.hashtagView indexPathsForSelectedItems])
    {
        NSString *hashtagString = [self.hashtags objectAtIndex:[indexPath row]];
        [selectedHashtagStrings addObject:hashtagString];
    }

    
    for (NSString *hashtagString in selectedHashtagStrings)
    {
       
        isExisting = NO;
        // Address existing hashtags
        for (Hashtag *existingHashtag in self.place.hashtagList)
        {
            if ([existingHashtag.text isEqualToString:hashtagString])
            {
                [existingHashtag addReview];
                isExisting = YES;
                break;
            }
        }
        
        // New hashtag
        if (!isExisting)
        {
            [self.place addHashtag:hashtagString];
        }
    }
    
    

    [KefiService AddReviewforPlace:self.place withSentiment:self.sentimentLevel withEnergy:self.energyLevel withHashtagStrings:selectedHashtagStrings];

    // manually segue here to PlaceDetailView

    
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
    return self.hashtags.count;
}

#pragma mark - UICollectionView Datasource
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HashtagCollectionCell *myCell = [collectionView
                                     dequeueReusableCellWithReuseIdentifier:@"hashtagCell"
                                     forIndexPath:indexPath];
    
    NSString *temp = self.hashtags[indexPath.row];
 
    [myCell.textLabel setText:temp];
    [myCell.textLabel setFont:[UIFont systemFontOfSize:12]];
    [myCell.textLabel setTextColor:self.view.tintColor];
    
    /*
    [myCell.layer setBorderWidth:2];
    [myCell.layer setBorderColor:[UIColor grayColor].CGColor];
    [myCell.layer setCornerRadius:10];
    */
    
    return myCell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    NSString *temp = self.hashtags[indexPath.row];
    UILabel *label = [[UILabel alloc]init];
 
    //set button text and assign to hashtagToggle
    [label setText:temp];
    [label setFont:[UIFont systemFontOfSize:14]];
    [label sizeToFit];
 
    return CGSizeMake(label.frame.size.width + 4, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0; // This is the minimum inter item spacing, can be more
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
    // space between cells on different lines
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    //send to addHashtagToCollection to add to collection view as selected
    NSString *text = textField.text;
    
    if (![text  isEqual: @""]) {
       
        //loop through hashtagItems in place, check to see if hashtag.text isn't in there
        for(Hashtag *hashtag in self.place.hashtagList) {
            if ([[text lowercaseString] isEqual:[hashtag.text lowercaseString]]) {
                // NSLog(@"same");
                
                // ToDo: UI to say already selected
                
                return NO;
            }
        }
        
        [self.hashtags addObject:text];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[self.hashtags count]-1 inSection:0];
        [self.hashtagView insertItemsAtIndexPaths:@[indexPath]];
        HashtagCollectionCell *cell = (HashtagCollectionCell *)[self.hashtagView cellForItemAtIndexPath:indexPath];
        [self.hashtagView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        cell.textLabel.textColor = [UIColor redColor];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HashtagCollectionCell *cell = (HashtagCollectionCell *)[self.hashtagView cellForItemAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor redColor];

    
    NSLog(@"%@", self.hashtags);
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath

{
    HashtagCollectionCell *cell = (HashtagCollectionCell *)[self.hashtagView cellForItemAtIndexPath:indexPath];
    [cell.textLabel setTextColor:self.view.tintColor];

}



/*

-(void)deselectHashtag:(HashtagCollectionCell *) cell {
    cell.hashtag.isSelected = NO;
    [cell.hashtagToggle setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    
    //remove from hashtags
    NSString *hashtagString = [[NSString alloc] init];
    hashtagString = [NSString stringWithFormat:@"%@", cell.hashtag.text];
    NSUInteger index = [self.hashtags indexOfObject:[NSString stringWithFormat:@"%@", cell.hashtag.text]];
    [self.hashtags removeObjectAtIndex:index];
}

-(void)selectHashtag:(HashtagCollectionCell *)cell withButton:(UIButton *) button {
    cell.hashtag.isSelected = YES;
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    
    //add to selected arrays
    [self.hashtags addObject:cell.hashtag.text];

}

- (IBAction)removeHashtagsFromList:(id)sender {
    NSMutableArray *newPlaceList = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[self.place.hashtagList count]; i++) {
        Hashtag *hashtag = self.place.hashtagList[i];
        NSLog(@"working with hashtag %@, index %d", hashtag.text, i);
        if ([hashtag.score integerValue] != (int)0) {
            [newPlaceList addObject:[self.place.hashtagList objectAtIndex:i]];
            NSLog(@"adding hashtag %@", self.place.hashtagList[i]);
            }
    }
    
    self.place.hashtagList = newPlaceList;
}*/

@end

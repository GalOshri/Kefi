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
@property (weak, nonatomic) IBOutlet UIButton *cancelBUtton;

@property (strong, nonatomic) NSMutableArray *hashtags;


@property (nonatomic, strong) KefiService *kefiService;

@end

@implementation SubmitReviewDetailView


#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.reviewDetailLabel.text = self.reviewDetailLabelText;
    self.placeLabel.text = self.place.name;
    [self.placeLabel sizeToFit];
    self.placeLabel.textAlignment = NSTextAlignmentLeft;
    self.reviewDetailLabel.textAlignment = NSTextAlignmentLeft;
    
    self.hashtags = [[NSMutableArray alloc] initWithObjects:nil];
}

// Adjust layout to match previous view
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    NSDictionary *horizontalToSentimentDict = @{@0:@"soPissed.png",
                                                @1:@"eh.png",
                                                @3:@"semiHappy.png",
                                                @4:@"soHappy.png"};
    
    NSArray *energyLevels = @[self.firstEnergyCircle, self.secondEnergyCircle, self.thirdEnergyCircle];
    
    
    self.placeLabel.frame = self.placeLabelFrame;
    self.reviewDetailLabel.frame = self.reviewDetailLabelFrame;

    self.sentimentImage.frame = self.imageFrame;
    self.sentimentImage.image = [UIImage imageNamed:[horizontalToSentimentDict objectForKey:[NSNumber numberWithInt:self.sentimentLevel]]];
    
    
    //animate placeName and reviewdetail labels down
    
    [UIView animateWithDuration:0.5 animations:^{
        self.placeLabel.frame = CGRectMake(self.sentimentImage.frame.origin.x + self.sentimentImage.frame.size.width + 15, self.sentimentImage.frame.origin.y, self.placeLabel.frame.size.width, self.placeLabel.frame.size.height);
        
        self.reviewDetailLabel.frame = CGRectMake(self.placeLabel.frame.origin.x, self.placeLabel.frame.origin.y + 15, self.reviewDetailLabel.frame.size.width, self.reviewDetailLabel.frame.size.height);
        
        
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
                imageView.frame = CGRectMake(count * 40 + self.reviewDetailLabel.frame.origin.x, self.reviewDetailLabel.frame.origin.y + 10, imageView.frame.size.width, imageView.frame.size.height);
            
                [imageView setHidden:NO];
            
            }
        
            //hide or unhide things
            [self.reviewDetailLabel setHidden:YES];
            [self.cancelBUtton setHidden:NO];
            [self.submitButton setHidden:NO];
        }
    }];
    
    //uicollectionview background color
    self.hashtagView.backgroundColor = [UIColor whiteColor];

        
}
    

#pragma mark - Submission methods
- (IBAction)submitReview:(UIButton *)sender {
    // Update place's sentiment and energy
    [self.place submitSentiment:self.sentimentLevel];
    [self.place submitEnergy:self.energyLevel];
    [self.place updateLastReviewTime];
    
    bool isExisting;
    
    for (NSString *hashtagString in self.hashtags)
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

    [KefiService AddReviewforPlace:self.place withSentiment:self.sentimentLevel withEnergy:self.energyLevel withHashtagStrings:self.hashtags];
    
}


#pragma mark - Selecting/Deslecting hashtags
- (IBAction)selectHashtags:(UIButton *)hashtagButton {
    HashtagCollectionCell *hashtagCell = (HashtagCollectionCell *)hashtagButton.superview.superview;

    //if not selected, select it
    if (hashtagCell.isSelected) {
        hashtagCell.isSelected = NO;
        [hashtagCell.hashtagToggle setTitleColor:self.view.tintColor forState:UIControlStateNormal];
        
        //remove from hashtags
        NSString *hashtagString = [[NSString alloc] init];
        hashtagString = [NSString stringWithFormat:@"%@", hashtagCell.hashtag.text];
        NSUInteger index = [self.hashtags indexOfObject:[NSString stringWithFormat:@"%@", hashtagCell.hashtag.text]];
        [self.hashtags removeObjectAtIndex:index];
    }

    //if selected, deselect it
    else {
        hashtagCell.isSelected = YES;
        [hashtagButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        
        //add to selected arrays
        [self.hashtags addObject:hashtagCell.hashtag.text];
        
    }
    
    
    NSLog(@"%@", self.hashtags);
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
    UIButton *button = (UIButton *)[myCell viewWithTag:100];
    //set button text and assign to hashtagToggle
    [button setTitle:temp.text forState:UIControlStateNormal];

    
    myCell.hashtagToggle = button;
    NSLog(@"%@", myCell.hashtagToggle.titleLabel);
    myCell.isSelected = NO;
    myCell.hashtag = temp;
    
    //play with cells
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    /*
    [myCell.layer setBorderWidth:2];
    [myCell.layer setBorderColor:[UIColor grayColor].CGColor];
    [myCell.layer setCornerRadius:10];
     */
    
    return myCell;
}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
    NSLog(@"selecting works Now");
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}



- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    Hashtag *temp = self.place.hashtagList[indexPath.row];
    UIButton *button = [[UIButton alloc]init];
    
    //set button text and assign to hashtagToggle
    [button setTitle:temp.text forState:UIControlStateNormal];
    [button sizeToFit];
    
    
    return CGSizeMake(button.frame.size.width, 20);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0; // This is the minimum inter item spacing, can be more
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
    // space between cells on different lines
}


@end

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
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>


@interface SubmitReviewDetailView ()

@property (strong, nonatomic) IBOutlet UILabel *reviewDetailLabel;
@property (strong, nonatomic) IBOutlet UILabel *placeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *firstEnergyCircle;
@property (weak, nonatomic) IBOutlet UIImageView *secondEnergyCircle;
@property (weak, nonatomic) IBOutlet UIImageView *thirdEnergyCircle;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) NSMutableArray *hashtags;
@property (weak, nonatomic) IBOutlet UITextField *hashtagTextField;

@property (nonatomic, strong) KefiService *kefiService;
@property (nonatomic) BOOL firstRun;

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *foursquareButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;

@end


@implementation SubmitReviewDetailView


#pragma mark - View Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.firstRun = YES;
    
    // manually change sentiment if greater than 2 to sentiment - 1
    // because our "2" is merely a placeholder and this messes up calculation

    if (self.sentimentLevel > 3)
        self.sentimentLevel -= 1;

    // uicollectionview background color
    self.hashtagView.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];

    self.hashtags = [[NSMutableArray alloc] init];
    for (Hashtag *hashtag in self.place.hashtagList)
        [self.hashtags addObject:hashtag.text];
    
    // Add Kefi hashtags
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    NSArray *kefiHashtags = [userData objectForKey:@"kefiHashtags"];
    for (NSString *hashtag in kefiHashtags)
    {
        if (![self.hashtags containsObject:hashtag])
            [self.hashtags addObject:hashtag];
    }
    
    
    self.hashtagView.delegate = self;
    self.hashtagView.dataSource = self;
    self.hashtagView.allowsMultipleSelection = YES;
    
    //round corners of fb and fsq img
    [[self.foursquareButton layer] setCornerRadius:2];
    [[self.foursquareButton layer] setMasksToBounds:YES];
    [[self. facebookButton layer] setCornerRadius:2];
    [[self.facebookButton layer] setMasksToBounds:YES];
    
    
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    // create image and labels
    NSDictionary *sentimentToImageDict = @{@1:@"soPissed.png",
                                           @2:@"eh.png",
                                           @3:@"semiHappy.png",
                                           @4:@"soHappy.png"};
    // self.sentimentImage = [[UIImageView alloc] init];
    self.sentimentImage.image = [UIImage imageNamed:[sentimentToImageDict objectForKey:[NSNumber numberWithInt:self.sentimentLevel]]];
    self.sentimentImage.frame = self.imageFrame;
    
   // self.placeLabel = [[UILabel alloc] init];
    [self.placeLabel setText:self.place.name];
    [self.placeLabel sizeToFit];
    
    
    // self.reviewDetailLabel = [[UILabel alloc] init];
    [self.reviewDetailLabel setText: self.reviewDetailLabelText];
    [self.reviewDetailLabel sizeToFit];
    
    /*[self.view addSubview:self.sentimentImage];
    [self.view addSubview:self.placeLabel];
    [self.view addSubview:self.reviewDetailLabel];*/
    
    
    if (self.firstRun) {
        [self.placeLabel setFrame:self.placeLabelFrame];
        [self.reviewDetailLabel setCenter:self.reviewDetailLabelCenter];
        self.placeLabel.textAlignment = NSTextAlignmentLeft;
        self.reviewDetailLabel.textAlignment = NSTextAlignmentLeft;
        
        NSArray *energyLevels = @[self.firstEnergyCircle, self.secondEnergyCircle, self.thirdEnergyCircle];

        // animate placeName and reviewdetail labels down
        [UIView animateWithDuration:0.5 animations:^{
            self.placeLabel.frame = CGRectMake(self.sentimentImage.frame.origin.x + self.sentimentImage.frame.size.width + 15, self.sentimentImage.frame.origin.y + 20.0, self.placeLabel.frame.size.width, self.placeLabel.frame.size.height);
            
            self.reviewDetailLabel.frame = CGRectMake(self.placeLabel.frame.origin.x, self.sentimentImage.frame.origin.y + 30, self.reviewDetailLabel.frame.size.width, self.reviewDetailLabel.frame.size.height);
            
            
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
                    imageView.frame = CGRectMake(count * 43 + self.reviewDetailLabel.frame.origin.x - 2, self.sentimentImage.frame.origin.y + 31, imageView.frame.size.width, imageView.frame.size.height);
                
                    [imageView setHidden:NO];
                }
            
                //hide or unhide things
                [self.reviewDetailLabel setHidden:YES];
                [self.cancelButton setHidden:NO];
                [self.submitButton setHidden:NO];
            }
        }];
        
        self.firstRun = NO;
    }
}


- (IBAction)facebookSelector:(id)sender
{
    if ([self.facebookButton isSelected])
    {
        [self.facebookButton setSelected:NO];
        [self.facebookButton setAlpha:0.3];
    }
    else
    {
        [self.facebookButton setSelected:YES];
        [self.facebookButton setAlpha:1.0];
    }
    
}

- (IBAction)twitterSelector:(id)sender
{
    if ([self.twitterButton isSelected])
    {
        [self.twitterButton setSelected:NO];
        [self.twitterButton setAlpha:0.3];
    }
    else
    {
        [self.twitterButton setSelected:YES];
        [self.twitterButton setAlpha:1.0];
    }
}

- (IBAction)foursquareSelector:(id)sender
{
    if ([self.foursquareButton isSelected])
    {
        [self.foursquareButton setSelected:NO];
        [self.foursquareButton setAlpha:0.3];
    }
    else
    {
        [self.foursquareButton setSelected:YES];
        [self.foursquareButton setAlpha:1.0];
    }
}

#pragma mark - Submission methods
- (IBAction)submitReview:(UIButton *)sender {
     bool isExisting;
    
    self.selectedHashtagStrings = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in [self.hashtagView indexPathsForSelectedItems])
    {
        NSString *hashtagString = [self.hashtags objectAtIndex:[indexPath row]];
        [self.selectedHashtagStrings addObject:hashtagString];
    }

    
    for (NSString *hashtagString in self.selectedHashtagStrings)
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
    
    // Submit to Twitter
    if (self.twitterButton.isSelected)
    {
        if ([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]])
        {
            NSString *tweet = [NSString stringWithFormat:@"I'm at %@ and it's ", self.place.name];
            for (NSString *hashtag in self.selectedHashtagStrings)
            {
                if ([tweet length] + [hashtag length] < 140)
                    tweet = [tweet stringByAppendingFormat:@"#%@ ", hashtag];
                
            }
            
            NSURL *submitTweet = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:submitTweet];
            NSString *postString = [NSString stringWithFormat:@"status=%@", tweet];
            postString = [postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            postString = [postString stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
            NSData *parameters = [postString dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:parameters];
            [request setHTTPMethod:@"POST"];
            [[PFTwitterUtils twitter] signRequest:request];
            NSURLResponse *response = nil;
            NSError *error = nil;
            [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
            NSLog(@"Error: %@", error);
            NSLog(@"Response: %@", response);
            NSLog(@"posted to twitter");

        }
    }
    
    // Submit to Facebook
    if (self.facebookButton.isSelected)
    {
        if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
        {
            NSString *status = [NSString stringWithFormat:@"I'm at %@ and it's ", self.place.name];
            for (NSString *hashtag in self.selectedHashtagStrings)
            {
                if ([status length] + [hashtag length] < 300)
                    status = [status stringByAppendingFormat:@"#%@ ", hashtag];
                
            }
            
            FBRequest *request = [FBRequest requestForPostStatusUpdate:status];
            // Send request to Facebook
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                // handle response
                NSLog(@"Error: %@", error);
                NSLog(@"posted to facebook");
            }];

        }
    }

    // manually segue here to PlaceDetailView
    [self performSegueWithIdentifier:@"UnwindDamnit" sender:self];
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
    [myCell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [myCell.textLabel setTextColor: [UIColor whiteColor]];
    
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
 
    return CGSizeMake(label.frame.size.width + 4, 30);
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
        for(NSString *hashtag in self.hashtags) {
            if ([[text lowercaseString] isEqual:[hashtag lowercaseString]]) {
                
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
        
        self.hashtagTextField.text = nil;
        [self.hashtagTextField resignFirstResponder];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HashtagCollectionCell *cell = (HashtagCollectionCell *)[self.hashtagView cellForItemAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor redColor];
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath

{
    HashtagCollectionCell *cell = (HashtagCollectionCell *)[self.hashtagView cellForItemAtIndexPath:indexPath];
    [cell.textLabel setTextColor: [UIColor whiteColor]];

}


- (IBAction)didSubmitFacebook:(id)sender {
    
    
    
}





@end

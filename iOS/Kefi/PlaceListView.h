//
//  PlaceListView.h
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PlaceList.h"
#import <Parse/Parse.h>

@interface PlaceListView : UITableViewController <CLLocationManagerDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) PlaceList *placeList;
@property (nonatomic, strong) NSMutableArray *hashtagList;
@property (nonatomic, strong) NSMutableArray *hashtagCatList;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

- (IBAction)unwindToList:(UIStoryboardSegue *)segue;

@end
    
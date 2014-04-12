//
//  PlaceDetailView.h
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface PlaceDetailView : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) Place *place;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

//
//  PlaceListView.h
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceList.h"

@interface PlaceListView : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PlaceList *placeList;

@end

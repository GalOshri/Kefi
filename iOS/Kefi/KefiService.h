//
//  KefiService.h
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceList.h"

@interface KefiService : NSObject

+ (void) PopulatePlaceList:(PlaceList *)placeList withTable:(UITableView *)tableView;

@end

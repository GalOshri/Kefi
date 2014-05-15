//
//  Review.h
//  Kefi
//
//  Created by Paul Stavropoulos on 5/14/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "place.h"

@interface Review : NSObject

@property (nonatomic, strong) NSNumber *sentiment;
@property (nonatomic, strong) NSNumber *energyLevel;
@property (nonatomic, strong) NSDate *submitTime;
@property (nonatomic, strong) NSMutableArray *hashtags;

@end

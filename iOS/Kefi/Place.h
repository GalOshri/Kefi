//
//  Place.h
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hashtag.h"

@interface Place : NSObject

@property (nonatomic, strong) NSString *fsId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *crossStreet;
@property (nonatomic, strong) NSMutableArray *hashtagList;
@property (nonatomic, strong) NSNumber *currentDistance;
@property (nonatomic, strong) UIImage *imageType;
@property (nonatomic, strong) NSString *categoryType;
@property (nonatomic, strong) NSArray *latLong;

- (id)initWithId:(NSString *)fsId
        WithName:(NSString *)placeName;

@end

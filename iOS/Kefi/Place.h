//
//  Place.h
//  Kefi
//
//  Created by Gal Oshri on 4/5/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

@property (nonatomic, strong) NSString *fsId;
@property (nonatomic, strong) NSString *name;

- (id)initWithId:(NSString *)fsId
        WithName:(NSString *)placeName;

@end
//
//  Review.h
//  Kefi
//
//  Created by Gal Oshri on 6/26/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Review : NSObject

@property (nonatomic) int sentiment;
@property (nonatomic) int energy;
@property (nonatomic, strong) NSMutableArray *hashtags;
@property (nonatomic, strong) NSDate *reviewTime;
@property (nonatomic, strong) NSString *placeName;

@end

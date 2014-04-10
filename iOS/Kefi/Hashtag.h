//
//  Hashtag.h
//  Kefi
//
//  Created by Gal Oshri on 4/9/14.
//  Copyright (c) 2014 Kefi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hashtag : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSNumber *score;

@end

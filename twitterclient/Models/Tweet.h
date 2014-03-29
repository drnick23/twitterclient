//
//  Tweet.h
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (strong,nonatomic) NSString *tweetId;
@property (strong,nonatomic) User *user;
@property (strong,nonatomic) NSString *text;
@property (nonatomic,assign) NSUInteger favorited;
@property (nonatomic,assign) NSUInteger retweeted;
@property (nonatomic,assign) NSUInteger favoriteCount;
@property (nonatomic,assign) NSUInteger retweetCount;
@property (nonatomic,strong) NSDate *createdAt;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

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

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

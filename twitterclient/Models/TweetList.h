//
//  TweetList.h
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

@interface TweetList : NSObject

- (id)initFromDictionary:(NSDictionary *)dictionary;

- (void)add:(Tweet *)tweet atTop:(BOOL)atTop;
- (Tweet *)get:(NSUInteger)index;
- (int) count;
@end

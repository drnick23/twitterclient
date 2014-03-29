//
//  Tweet.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "Tweet.h"


@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        //NSLog(@"Tweet:initFromDictionary %@",dictionary);
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.tweetId = dictionary[@"id"];
        self.text = dictionary[@"text"];
        self.favorited = [dictionary[@"favorited"] intValue];
        self.retweeted = [dictionary[@"retweeted"] intValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
        NSDate *date = [dateFormatter dateFromString:dictionary[@"created_at"]];
        //NSLog(@"converting twitter timestamp %@  to: [%@]",dictionary[@"created_at"],date);
        self.createdAt = date;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@] %@ - %@",self.tweetId,self.user.name,self.text];
}

@end

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
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@] %@ - %@",self.tweetId,self.user.name,self.text];
}

@end

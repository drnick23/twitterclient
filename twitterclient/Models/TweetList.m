//
//  TweetList.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "TweetList.h"

@interface TweetList()

@property (nonatomic,strong) NSMutableArray *tweetList;

@end

@implementation TweetList

- (NSMutableArray *)tweetList
{
    if (!_tweetList) _tweetList = [[NSMutableArray alloc] init];
    return _tweetList;
}

- (id)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        //NSLog(@"TweetList:initFromDictionary %@",dictionary);
        if([dictionary isKindOfClass:[NSArray class]]) {
            
            // add all our tweets to the list...
            for (NSDictionary *tweetData in dictionary) {
                Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetData];
                [self add:tweet atTop:NO];
            }
            
        }
    }
    return self;
}

- (void)add:(Tweet *)tweet atTop:(BOOL)atTop
{
    if (atTop) {
        [self.tweetList insertObject:tweet atIndex:0];
    } else {
        [self.tweetList addObject:tweet];
    }
    NSLog(@"added tweet to list %@",tweet.description);
}

- (Tweet *) get:(NSUInteger) index
{
    return [self.tweetList objectAtIndex:index];
}

- (int) count
{
    return [self.tweetList count];
}



@end
//
//  TwitterClient.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/27/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "TwitterClient.h"

@implementation TwitterClient

+ (TwitterClient *) instance {
    static TwitterClient *instance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:@"7StXmIWWY41AlPejp7wpg" consumerSecret:@"B519mICav67cqWDWNzXarmArBANwf9W749zx28"];
    });
    
    return instance;
}

- (void) login {
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"drnick23twitter://oauth"] scope:nil
    success:^(BDBOAuthToken *requestToken) {
        NSLog(@"got the request token %@",requestToken);
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        
        // open up twitter page in safari
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
        
    }
    failure:^(NSError *error) {
        NSLog(@"Error TwitterClient Login: %@",error);
    }];
}

- (AFHTTPRequestOperation *) homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
}

@end

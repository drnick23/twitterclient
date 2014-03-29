//
//  TwitterClient.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/27/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "TwitterClient.h"

@implementation TwitterClient

static const BOOL kTestingInDeveloperMode = YES;

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

- (AFHTTPRequestOperation *) verifyCredentialsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}


- (AFHTTPRequestOperation *) homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
}

- (AFHTTPRequestOperation *) homeTimelineWithParameters:parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    return [self GET:@"1.1/statuses/home_timeline.json" parameters:parameters success:success failure:failure];
}

- (AFHTTPRequestOperation *) updateStatus:(NSString *)status success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    if (kTestingInDeveloperMode) {
        NSLog(@"WARNING: in developer test mode, not actually tweeting, just getting your latest tweet");
        //return [self GET:@"1.1/statuses/home_timeline.json" parameters:nil success:success failure:failure];
        return [self GET:@"1.1/statuses/user_timeline.json" parameters:@{@"screen_name":@"drnicolas23",@"count":@1} success:success failure:failure];
    }
    else {
        return [self POST:@"1.1/statuses/update.json" parameters:@{@"status":status} success:success failure:failure];
    }
}

- (AFHTTPRequestOperation *) favoriteStatus:(NSString *)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    return [self POST:@"1.1/favorites/create.json" parameters:@{@"id":tweetId} success:success failure:failure];

}

- (AFHTTPRequestOperation *) unfavoriteStatus:(NSString *)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    return [self POST:@"1.1/favorites/destroy.json" parameters:@{@"id":tweetId} success:success failure:failure];
    
}


@end

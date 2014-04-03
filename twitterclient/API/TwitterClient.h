//
//  TwitterClient.h
//  twitterclient
//
//  Created by Nicolas Halper on 3/27/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDBOAuth1RequestOperationManager.h"

#define TESTING_ONLY @YES;

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)instance;

- (void) login;

- (AFHTTPRequestOperation *) verifyCredentialsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *) homeTimelineWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *) homeTimelineWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *) mentionsWithParameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


- (AFHTTPRequestOperation *) updateStatus:(NSString *)status inReplyToStatusId:(NSString *)inReplyToStatusId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *) favoriteStatus:(NSString *)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *) unfavoriteStatus:(NSString *)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *) retweetStatus:(NSString *)tweetId success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end

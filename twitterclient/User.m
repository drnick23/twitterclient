//
//  User.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/27/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "User.h"

@implementation User

static User *currentUser = nil;

+ (User *)currentUser {
    if (currentUser == nil) {
        NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
        if (dictionary) {
            //currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return currentUser;
}

+ (void)setCurrentUser:(User *)user {
    currentUser = user;
    
    // save to user defaults.
    // reference https://github.com/blog/1299-mantle-a-model-framework-for-objective-c
}

@end

//
//  User.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "User.h"

@implementation User

NSString *const UserDidLoginNotification = @"UserDidLoginNotification";
NSString *const UserDidLogoutNotification = @"UserDidLogoutNotification";

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
    
    if (user == nil) {
        NSLog(@"User set to nil: sending notification logged out");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLogoutNotification" object:nil];
    } else {
        NSLog(@"New user set: sending notifcation logged in");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLoginNotification" object:nil];
    }
    
    currentUser = user;
    
    // save to user defaults.
    // reference https://github.com/blog/1299-mantle-a-model-framework-for-objective-c
}

- (id) initWithDictionary:(NSDictionary *)dictionary {
    self = [super self];
    if (self) {
        NSLog(@"New user init: %@",dictionary);
    }
    return self;
}

@end

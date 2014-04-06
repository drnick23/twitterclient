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

NSString *const UserNSUserDefaultsSaveKey = @"User_currentUser";

static User *currentUser = nil;

+ (User *)currentUser {
    NSLog(@"User:currentUser");
    if (currentUser == nil) {
        NSLog(@"User:currentUser is nil");
        NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:UserNSUserDefaultsSaveKey];
        if (dictionary) {
            currentUser = [[User alloc] initWithDictionary:dictionary];
            NSLog(@"User:currentUser Loaded current user from persistent storage key:%@ %@", UserNSUserDefaultsSaveKey,dictionary);
        } else {
            NSLog(@"User:currentUser User is nil: no persistent storage user found key:%@ object:%@",UserNSUserDefaultsSaveKey,dictionary);
        }
    }
    return currentUser;
}

+ (void)setCurrentUser:(User *)user {
    NSLog(@"User:setCurrentUser %@",user);
    
    if (user == nil) {
        [currentUser deleteUserSession];
        currentUser = user;

        NSLog(@"User set to nil: sending notification logged out");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLogoutNotification" object:nil];
    } else {
        currentUser = user;
        [currentUser persistUserSession];
        NSLog(@"New user set: sending notifcation logged in");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidLoginNotification" object:nil];
    }
    
    
    
    // save to user defaults.
    // reference https://github.com/blog/1299-mantle-a-model-framework-for-objective-c
}

- (id) initWithDictionary:(NSDictionary *)dictionary {
    NSLog(@"User:initWithDictionary: %@",dictionary);
    self = [super self];
    if (self) {
        if (dictionary[@"id"]) {
            self.name = dictionary[@"name"];
            self.userId = dictionary[@"id"];
            self.screenName = dictionary[@"screen_name"];
            self.profileImageURL = [NSURL URLWithString:dictionary[@"profile_image_url"]];
            self.profileBackgroundImageURL = [NSURL URLWithString:dictionary[@"profile_background_image_url"]];
            self.profileBackgroundColor = dictionary[@"profile_background_color"];
            self.followersCount = dictionary[@"followers_count"];
            self.statusesCount = dictionary[@"statuses_count"];
            self.friendsCount = dictionary[@"friends_count"];
            
            //NSLog(@"User:initWithDictionary: %@ [%@]",self.name,self.userId);
        } else {
            self = nil;
        }
        
    }
    return self;
}

- (void) persistUserSession {
    NSDictionary *saveUser = @{
                               @"id":self.userId,
                               @"name":self.name,
                               @"screen_name":self.screenName,
                               @"profile_image_url":[self.profileImageURL absoluteString],
                               @"followers_count":self.followersCount,
                               @"statuses_count":self.statusesCount,
                               @"friends_count":self.friendsCount,
                               @"profile_background_image_url":[self.profileBackgroundImageURL absoluteString]
                               };
    NSLog(@"User:persistUserSession adding user TO persistent storage %@",saveUser);
    
    [[NSUserDefaults standardUserDefaults] setObject:saveUser forKey:UserNSUserDefaultsSaveKey];

 
    // debug code
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:UserNSUserDefaultsSaveKey];
    NSLog(@"User:persistUserSession saved key:'%@' -> %@",UserNSUserDefaultsSaveKey,dictionary);
}

- (void) deleteUserSession {
    NSLog(@"User:persistUserSession adding user from persistent storage");
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserNSUserDefaultsSaveKey];
    
    // debug code
    NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:UserNSUserDefaultsSaveKey];
    NSLog(@"User:deleteUserSession deleted key:'%@' -> %@",UserNSUserDefaultsSaveKey,dictionary);

}


- (NSString *)description {
    return [NSString stringWithFormat:@"User %@ [%@] tweets: %@",self.name,self.userId,self.profileBackgroundImageURL];
}

@end

//
//  User.h
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *screenName;
@property (nonatomic,strong) NSURL *profileImageURL;
@property (nonatomic,strong) NSURL *profileBackgroundImageURL;
@property (nonatomic,strong) NSString *profileBackgroundColor;
@property (nonatomic,strong) NSNumber *followersCount;
@property (nonatomic,strong) NSNumber *friendsCount;
@property (nonatomic,strong) NSNumber *statusesCount;


+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;

- initWithDictionary:(NSDictionary *) dictionary;


@end

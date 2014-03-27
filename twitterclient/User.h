//
//  User.h
//  twitterclient
//
//  Created by Nicolas Halper on 3/27/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)user;

@end

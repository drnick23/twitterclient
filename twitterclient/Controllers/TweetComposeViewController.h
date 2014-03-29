//
//  TweetComposeViewController.h
//  twitterclient
//
//  Created by Nicolas Halper on 3/29/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetComposeViewController;

@protocol TweetComposeViewControllerDelegate <NSObject>
-(void)updatedWithStatus:(Tweet *)tweet;
@end

@interface TweetComposeViewController : UIViewController <UITextViewDelegate>

@property (nonatomic,weak) id <TweetComposeViewControllerDelegate> delegate;

@end

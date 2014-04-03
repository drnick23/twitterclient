//
//  HomeViewController.h
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetComposeViewController.h"

enum FeedType {
    FT_HOME_TIMELINE,
    FT_USER_MENTIONS
};
typedef enum FeedType FeedType;


@interface TweetListViewController : UIViewController <TweetComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@property (nonatomic,assign) FeedType feed;

@end

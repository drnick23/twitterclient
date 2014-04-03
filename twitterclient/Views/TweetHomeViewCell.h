//
//  TweetHomeViewCell.h
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetHomeViewCell : UITableViewCell

@property (nonatomic,strong) Tweet *tweet;

-(void) animateFlash;

-(CGFloat)calculateHeightWithTweet:(Tweet *)tweet;

@property (weak, nonatomic) IBOutlet UIButton *favoritedButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@end

//
//  TweetHomeViewCell.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "TweetHomeViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface TweetHomeViewCell()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;


@end

@implementation TweetHomeViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    
    self.tweetTextLabel.text = tweet.text;
    self.userNameLabel.text = tweet.user.name;
    self.userScreenNameLabel.text = tweet.user.screenName;
    [self.userProfileImageView setImageWithURL:tweet.user.profileImageURL];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)animateFlash
{
    // TODO: animate flash effect on cell to show it's newly posted.
    NSLog(@"TweetHomeViewCell animateFlash:TODO");
}

@end

//
//  TweetHomeViewCell.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "TweetHomeViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MHPrettyDate.h"

CGFloat const kCellHeightCalculationExtra = 60;
CGFloat const kCellHeightCalculationMinHeight = 80;


@interface TweetHomeViewCell()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userCreatedAtLabel;

@property (weak, nonatomic) IBOutlet UILabel *retweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *favoritedImageView;
@property (weak, nonatomic) IBOutlet UILabel *repliesCountLabel;


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
    self.retweetsCountLabel.text = [NSString stringWithFormat:@"%d",tweet.retweetCount];
    self.favoritesCountLabel.text = [NSString stringWithFormat:@"%d",tweet.favoriteCount];
    self.repliesCountLabel.text = @""; // empty for now
    
    self.userCreatedAtLabel.text = [MHPrettyDate prettyDateFromDate:tweet.createdAt withFormat:MHPrettyDateShortRelativeTime];
    
    
    if (tweet.favorited) {
        self.favoritedButton.highlighted = YES;
    }
    if (tweet.retweeted) {
        self.retweetedImageView.highlighted = YES;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)animateFlash {
    // TODO: animate flash effect on cell to show it's newly posted.
    NSLog(@"TweetHomeViewCell animateFlash:TODO");
}

- (CGFloat)calculateHeightWithTweet:(Tweet *)tweet {
    /*NSDictionary *restaurant = restaurants[indexPath.row];
    NSString* restaurantNameStr = [NSString stringWithFormat:@"%@",restaurant[@"name"]];
    UIFont *font = [UIFont boldSystemFontOfSize: 12];
    CGRect rect = [restaurantNameStr boundingRectWithSize:CGSizeMake(RESTAURANT_LABEL_WIDTH, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName: font} context:nil];
    return rect.size.height + CELL_HEIGHT_EXTRA;*/
    UIFont *font = [UIFont systemFontOfSize: 14];
    CGRect rect = [tweet.text boundingRectWithSize:CGSizeMake(self.tweetTextLabel.bounds.size.width, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName: font} context:nil];
    CGFloat height = rect.size.height;
    
    return MAX(kCellHeightCalculationMinHeight,height + kCellHeightCalculationExtra);
}

@end

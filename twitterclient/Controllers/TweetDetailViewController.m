//
//  TweetDetailViewController.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface TweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;

@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;

@property (weak, nonatomic) IBOutlet UILabel *retweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

- (IBAction)onReplyButton:(id)sender;
- (IBAction)onRetweetButton:(id)sender;
- (IBAction)onFavoriteButton:(id)sender;


@end

@implementation TweetDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self refresh];
}

- (void)setTweet:(Tweet *)tweet {
    // link labels...
    NSLog(@"set tweet...");
    _tweet = tweet;
    [self refresh];
}

- (void)refresh {
    self.tweetTextLabel.text = self.tweet.text;
    self.userNameLabel.text = self.tweet.user.name;
    self.userScreenNameLabel.text = [NSString stringWithFormat:@"@%@",self.tweet.user.screenName];
    [self.userProfileImageView setImageWithURL:self.tweet.user.profileImageURL];
    self.retweetsCountLabel.text = [NSString stringWithFormat:@"%d RETWEETS",self.tweet.retweetCount];
    self.favoritesCountLabel.text = [NSString stringWithFormat:@"%d FAVORITES",self.tweet.favoriteCount];
    self.createdAtLabel.text = [NSDateFormatter localizedStringFromDate:self.tweet.createdAt
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterShortStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onReplyButton:(id)sender {
    NSLog(@"onReplyButton");
}

- (IBAction)onRetweetButton:(id)sender {
     NSLog(@"onRetweetButton");
    self.retweetButton.highlighted = !self.retweetButton.highlighted;
}

- (IBAction)onFavoriteButton:(id)sender {
    NSLog(@"onFavoriteButton");
    self.favoriteButton.highlighted = !self.favoriteButton.highlighted;
    
    if (!self.tweet.favorited) {
        NSLog(@"favoriting...");
        [[TwitterClient instance] favoriteStatus:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"tweet after call with favorite: %@",responseObject);
            self.tweet = [[Tweet alloc] initWithDictionary:responseObject];
            [self refresh];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"onTweetButton: could not favorite %@",error);
        }];
    } else {
        NSLog(@"unfavoriting...");
        [[TwitterClient instance] unfavoriteStatus:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"tweet after call with favorite: %@",responseObject);
            self.tweet = [[Tweet alloc] initWithDictionary:responseObject];
            [self refresh];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"onTweetButton: could not unfavorite %@",error);
        }];
    }
    
}
@end

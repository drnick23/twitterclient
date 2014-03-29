//
//  TweetDetailViewController.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScreenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;

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
    self.userScreenNameLabel.text = self.tweet.user.screenName;
    [self.userProfileImageView setImageWithURL:self.tweet.user.profileImageURL];
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
}
@end

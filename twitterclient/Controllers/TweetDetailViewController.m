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
    
    if (self.tweet.retweetCount > 0) {
        self.retweetsCountLabel.text = [NSString stringWithFormat:@"%d RETWEETS",self.tweet.retweetCount];
    } else {
        self.retweetsCountLabel.text = @"";
    }
    if (self.tweet.favoriteCount > 0) {
        self.favoritesCountLabel.text = [NSString stringWithFormat:@"%d FAVORITES",self.tweet.favoriteCount];
    } else {
        self.favoritesCountLabel.text = @"";
    }
    
    self.createdAtLabel.text = [NSDateFormatter localizedStringFromDate:self.tweet.createdAt
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterShortStyle];
    
    self.favoriteButton.selected = self.tweet.favorited;
    self.retweetButton.selected = self.tweet.retweeted;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onReplyButton:(id)sender {
    NSLog(@"onReplyButton");
    TweetComposeViewController *tweetComposeViewController = [[TweetComposeViewController alloc] init];
    tweetComposeViewController.delegate = self;
    tweetComposeViewController.tweetReplyTo = self.tweet;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tweetComposeViewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)updatedWithStatus:(Tweet *)tweet {
    NSLog(@"TweetDetailView:updateWithStatus %@",tweet.description);
    
    // let's add tweet to our timeline view
    /*[self.tweetList add:tweet atTop:YES];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];*/
    /*[self.tableView reloadData];
     [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationBottom];*/

    //[self.tableView reloadData];
}
- (IBAction)onRetweetButton:(id)sender {
     NSLog(@"onRetweetButton");
    self.retweetButton.highlighted = !self.retweetButton.highlighted;
    if (!self.tweet.retweeted) {
        NSLog(@"retweeting...");
        [[TwitterClient instance] retweetStatus:self.tweet.tweetId success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"tweet after call with retweet: %@",responseObject);
            self.tweet = [[Tweet alloc] initWithDictionary:responseObject];
            [self refresh];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"onTweetButton: could not retweet %@",error);
        }];
    } else {
        NSLog(@"already retweeted not doing anything...");
        
    }

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

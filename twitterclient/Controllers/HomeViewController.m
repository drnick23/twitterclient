//
//  HomeViewController.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "TweetDetailViewController.h"
#import "TweetComposeViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "TweetList.h"
#import "TweetHomeViewCell.h"


@interface HomeViewController () <UIGestureRecognizerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) TweetList *tweetList;

@property (nonatomic,assign) NSUInteger fetchMoreTweetsPastRow;

@property (nonatomic,strong) TweetHomeViewCell *prototypeCell;

@end

@implementation HomeViewController

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
    NSLog(@"HomeViewController:viewDidLoad");
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Configure the navigation bar
    self.navigationItem.title = @"Home";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton:)];
    self.navigationItem.leftBarButtonItem = leftButton;
                                   
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStyleBordered target:self action:@selector(onComposeButton:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    // add pull to refresh feature
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];

    // register our custom cells
    UINib *tweetHomeViewCellNib = [UINib nibWithNibName:@"TweetHomeViewCell" bundle:nil];
    [self.tableView registerNib:tweetHomeViewCellNib forCellReuseIdentifier:@"TweetHomeViewCell"];
    
    [self fetchMoreTweets];
    
}

- (void)fetchMoreTweets {
    NSLog(@"fetch more tweets");
    
    NSDictionary *parameters = nil;
    
    // if we have a tweetList already, get id of last tweet in list and fetch beyond that for infinite scroll
    if (self.tweetList) {
        parameters = @{@"max_id":[self.tweetList getMaxId]};
    }
    
    [[TwitterClient instance] homeTimelineWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"HomeViewController:viewDidLoad got timeline");// %@",responseObject);
        
        TweetList *tweetList = [[TweetList alloc] initWithDictionary:responseObject];
        if (!self.tweetList) {
            self.tweetList = tweetList;
        } else {
            [self.tweetList appendWithTweetList:tweetList];
        }
        self.fetchMoreTweetsPastRow = [self.tweetList count]-3;
        NSLog(@"Will fetch more tweets past row %d",self.fetchMoreTweetsPastRow);
        
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HomeViewController:viewDidLoad could not get timeline %@",error);
    }];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    NSLog(@"refresh control");
    [refreshControl endRefreshing];
    
    NSDictionary *parameters = nil;
    NSString *newestId = [self.tweetList getNewestId];
    
    // only bother fetching new list if new stuff has happened.
    if (newestId) {
        parameters = @{@"since_id":newestId};
        [[TwitterClient instance] homeTimelineWithParameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"HomeViewController:viewDidLoad got timeline since %@ -> %@",parameters,responseObject);
            
            TweetList *newTweets = [[TweetList alloc] initWithDictionary:responseObject];
            
            if ([newTweets count]>0) {
                NSLog(@"Got %d new tweets...prepending to List",[newTweets count]);
                // append to existing tweetList
                [self.tweetList prependWithTweetList:newTweets];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            }
 
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"HomeViewController:viewDidLoad could not get timeline %@",error);
        }];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweetList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Tweet *tweet = [self.tweetList get:indexPath.row];
    return [self.prototypeCell calculateHeightWithTweet:tweet];
    
}

- (TweetHomeViewCell *)prototypeCell
{
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetHomeViewCell"];
    }
    return _prototypeCell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet *tweet = [self.tweetList get:indexPath.row];
    
    TweetHomeViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetHomeViewCell" forIndexPath:indexPath];
    cell.tweet = tweet;
    
    // connect our mini-buttons to actions on this controller
    cell.replyButton.tag = indexPath.row;
    [cell.replyButton addTarget:self action:@selector(replyTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.retweetButton.tag = indexPath.row;
    [cell.retweetButton addTarget:self action:@selector(retweetTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.favoritedButton.tag = indexPath.row;
    [cell.favoritedButton addTarget:self action:@selector(favoritedTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(profileTapped:)];
    cell.userProfileImageView.tag = indexPath.row;
    [cell.userProfileImageView setUserInteractionEnabled:YES];
    [tgr setDelegate:self];
    [cell.userProfileImageView addGestureRecognizer:tgr];
    
    
    // check if need to load more for infinite scroll
    if (self.fetchMoreTweetsPastRow && (indexPath.row > self.fetchMoreTweetsPastRow)) {
        // set to 0 so it won't keep requesting fetches until it's actually done fetching one.
        self.fetchMoreTweetsPastRow = 0;
        [self fetchMoreTweets];
    }
    
    return cell;
}

- (void)replyTapped:(UIButton *)sel {
    NSLog(@"tapped on reply");
    Tweet *tweet = [self.tweetList get:sel.tag];
    
    TweetComposeViewController *tweetComposeViewController = [[TweetComposeViewController alloc] init];
    tweetComposeViewController.delegate = self;
    tweetComposeViewController.tweetReplyTo = tweet;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tweetComposeViewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

- (void)retweetTapped:(UIButton *)sel {
    
    Tweet *tweet = [self.tweetList get:sel.tag];
    NSLog(@"retweeted tweet %@",tweet.description);
    NSLog(@"TODO NOTE: didn't tie in to actual retweeting yet...would need to do a call on client for that but for this demo was ommited");
    
    if (!tweet.retweeted) {
        tweet.retweeted = YES;
        tweet.retweetCount += 1;
    } else {
        NSLog(@"todo: do dialogue to un-retweet");
        tweet.retweeted = NO;
        tweet.retweetCount -= 1;
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:sel.tag inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationBottom];
    
}

- (void)favoritedTapped:(UIButton *)sel {
    
    Tweet *tweet = [self.tweetList get:sel.tag];
    NSLog(@"favorited tweet %@",tweet.description);
    NSLog(@"TODO NOTE: didn't tie in to actual favoriting yet...would need to do a call on client for that but for this demo was ommited");
    
    if (!tweet.favorited) {
        tweet.favorited = YES;
        tweet.favoriteCount += 1;
    } else {
        tweet.favorited = NO;
        tweet.favoriteCount -= 1;
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:sel.tag inSection:0];

    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationBottom];
    
}

- (void)profileTapped:(UIGestureRecognizer *)tap {
    
    Tweet *tweet = [self.tweetList get:tap.view.tag];
    NSLog(@"profile was tapped, got user %@",tweet.user);
    // slide in profile view controller
    ProfileViewController *profileViewController = [[ProfileViewController alloc] init];
    profileViewController.user = tweet.user;
    [self.navigationController pushViewController:profileViewController animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TweetHomeViewCell *cell = (TweetHomeViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"You selected %@",cell.tweet.text);
    
    TweetDetailViewController *tweetDetailViewController = [[TweetDetailViewController alloc] init];
    tweetDetailViewController.tweet = cell.tweet;
    
    [self.navigationController pushViewController:tweetDetailViewController animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSignOutButton:(id)sender {
    NSLog(@"Sign out");
    [User setCurrentUser:nil];
}

- (void)onComposeButton:(id)sender {
    // pop up modal compose view controller
    TweetComposeViewController *tweetComposeViewController = [[TweetComposeViewController alloc] init];
    tweetComposeViewController.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tweetComposeViewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)updatedWithStatus:(Tweet *)tweet {
    NSLog(@"Home view should now animate in tweet:%@",tweet.description);
    
    // let's add tweet to our timeline view
    [self.tweetList add:tweet atTop:YES];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
 
    TweetHomeViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetHomeViewCell" forIndexPath:path];
    [cell animateFlash];

}

@end

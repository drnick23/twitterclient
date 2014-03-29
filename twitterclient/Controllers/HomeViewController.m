//
//  HomeViewController.m
//  twitterclient
//
//  Created by Nicolas Halper on 3/28/14.
//  Copyright (c) 2014 Nicolas Halper. All rights reserved.
//

#import "HomeViewController.h"
#import "TweetDetailViewController.h"
#import "TweetComposeViewController.h"
#import "TwitterClient.h"
#import "User.h"
#import "TweetList.h"
#import "TweetHomeViewCell.h"


@interface HomeViewController ()


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) TweetList *tweetList;

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
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    
    // Configure the navigation bar
    self.navigationItem.title = @"Home";
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton:)];
    self.navigationItem.leftBarButtonItem = leftButton;
                                   
    /*UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"rightButton"] style:UIBarButtonItemStylePlain target:self action:@selector(onRightButton:)];
    self.navigationItem.rightBarButtonItem = rightButton;*/
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStyleBordered target:self action:@selector(onComposeButton:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    // register our custom cells
    UINib *tweetHomeViewCellNib = [UINib nibWithNibName:@"TweetHomeViewCell" bundle:nil];
    [self.tableView registerNib:tweetHomeViewCellNib forCellReuseIdentifier:@"TweetHomeViewCell"];
    
    
    [[TwitterClient instance] homeTimelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"HomeViewController:viewDidLoad got timeline");
        self.tweetList = [[TweetList alloc] initFromDictionary:responseObject];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HomeViewController:viewDidLoad could not get timeline");
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tweetList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet *tweet = [self.tweetList get:indexPath.row];
    
    TweetHomeViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetHomeViewCell" forIndexPath:indexPath];
    cell.tweet = tweet;
    NSLog(@"dequeued tweet: %@",tweet.description);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Display Alert Message
    TweetHomeViewCell *cell = (TweetHomeViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"You selected %@",cell.tweet.text);
    
    TweetDetailViewController *tweetDetailViewController = [[TweetDetailViewController alloc] initWithTweet:cell.tweet];
    
    if (!self.navigationController) {
        NSLog(@"TODO: no navigation controller here");
    }
    [self.navigationController pushViewController:tweetDetailViewController animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSignOutButton:(id)sender {
    [User setCurrentUser:nil];
    NSLog(@"Sign out");
}

- (void)onComposeButton:(id)sender {
    // pop up modal compose view controller
    TweetComposeViewController *tweetComposeViewController = [[TweetComposeViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tweetComposeViewController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:navigationController animated:YES completion:nil];
    NSLog(@"Sign out");
}
@end
